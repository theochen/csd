require 'helper'
require 'ostruct'

class TestCommands < Test::Unit::TestCase
  
  include CSD
  
  DUMMY_TEXT = %q{PART I

NIGHT

A high vaulted narrow Gothic chamber.
FAUST, restless, seated at his desk.

FAUST

I HAVE, alas! Philosophy,
Medicine, Jurisprudence too,
And to my cost Theology,
With ardent labour, studied through.
And here I stand, with all my lore,
Poor fool, no wiser than before.
Magister, doctor styled, indeed,
Already these ten years I lead,
Up, down, across, and to and fro,
My pupils by the nose,--and learn,
That we in truth can nothing know!}

  DUMMY_GIT = 'http://github.com/csd/dummy.git'
  
  context "As a directory function" do
  
    setup do
      Options.silent = true
      Options.reveal = false
      @tmp    = Pathname.new Dir.mktmpdir
      @dir    = Pathname.new File.join(@tmp, 'folder')
      @subdir = Pathname.new File.join(@dir, 'subfolder')
    end

    teardown do
      assert FileUtils.rm_r(@tmp)
    end
    
    context "mkdir" do
  
      should "return the proper CommandResult if the directory already existed" do
        ensure_mkdir(@dir)
        assert_kind_of(CommandResult, result = Cmd.mkdir(@dir))
        assert result.success?
        assert result.already_existed?
        assert result.writable?
      end
      
      should "return a successful CommandResult but not actually do anything in reveal mode" do
        Options.reveal = true
        assert_kind_of(CommandResult, result = Cmd.mkdir(@dir))
        assert !@dir.directory?
        assert result.success?
        assert !result.already_existed?
        assert result.writable?
      end
      
      should "create the directory if it doesn't exist yet" do
        assert_kind_of(CommandResult, result = Cmd.mkdir(@dir))
        assert result.success?
        assert !result.already_existed?
        assert result.writable?
      end
      
      should "notify if there is no permission to create a new directory without die_on_failure" do
        ensure_mkdir(@dir)
        @dir.chmod(0000)
        assert_kind_of(CommandResult, result = Cmd.mkdir(File.join(@dir, 'subdir_in_readonly_dir'), :die_on_failure => false))
        if superuser?
          assert result.success?
          assert result.writable?
        else
          assert !result.success?
          assert !result.writable?
        end
        assert !result.already_existed?
        @dir.chmod(0777) # Cleanup
      end
      
      should "notify if there is no permission to create a new directory with die_on_failure" do
        ensure_mkdir(@dir)
        @dir.chmod(0000)
        assert_raise(Error::Command::MkdirFailed) {
          Cmd.mkdir(File.join(@dir, 'subdir_in_readonly_dir'), :die_on_failure => true)
        } unless superuser?
        @dir.chmod(0777) # Cleanup
      end
      
      should "notify if there is no permission to create an existing directory" do
        ensure_mkdir(@dir)
        @dir.chmod(0000)
        assert_kind_of(CommandResult, result = Cmd.mkdir(@dir))
        assert result.success?
        assert result.already_existed?
        superuser? ? assert(result.writable?) : assert(!result.writable?)
        @dir.chmod(0777) # Cleanup
      end
      
    end # context "mkdir"

    context "cd" do
      
      should "return a CommanResult with success? if the directory was changed successfully" do
        assert_kind_of(CommandResult, result = Cmd.cd('/'))
        assert result.success?
        assert_kind_of(CommandResult, result = Cmd.cd(@tmp))
        assert result.success?
      end
      
      should "realize when the target is not a directory, but a file or something without die_on_failure" do
        testfile_path = File.join(@tmp, 'testfile')
        File.new(testfile_path, 'w')
        assert_kind_of(CommandResult, result = Cmd.cd(testfile_path, :die_on_failure => false))
        assert !result.success?
      end
      
      should "realize when the target is not a directory, but a file or something with die_on_failure" do
        testfile_path = File.join(@tmp, 'testfile')
        assert_raise(Error::Command::CdFailed) {
          Cmd.cd(testfile_path, :die_on_failure => true)
        }
      end
      
      should "realize when the target doesn't exist without die_on_failure" do
        assert_kind_of(CommandResult, result = Cmd.cd('/i/for/sure/dont/exist', :die_on_failure => false))
        assert !result.success?
      end

      should "realize when the target doesn't exist with die_on_failure" do
        assert_raise(Error::Command::CdFailed) {
          Cmd.cd('/i/for/sure/dont/exist', :die_on_failure => true)
        }
      end
      
      should "fake changing the directory in reveal mode" do
        Options.reveal = true
        current_pwd = Dir.pwd
        assert_kind_of(CommandResult, result = Cmd.cd('/i/for/sure/dont/exist'))
        assert result.success?
        assert_equal current_pwd, Dir.pwd
      end
      
      should "actually change the directory in dry mode" do
        assert_not_equal '/', Dir.pwd
        assert result = Cmd.cd('/')
        assert result.success?
        assert_equal '/', Dir.pwd
      end
      
    end # context "cd"
  
    context "when working with files" do
      
      setup do
        ensure_mkdir(@dir)
        ensure_mkdir(@subdir)
        @file1 = Pathname.new File.join(@tmp, 'file1')
        @file2 = Pathname.new File.join(@tmp, 'file2')
        @file3 = Pathname.new File.join(@dir, 'file3')
        [@file1, @file2, @file3].each { |file| assert FileUtils.touch(file) }
      end

      teardown do
        assert FileUtils.rm_r(@tmp)
        Dir.chdir '/' # Since we're removing the current directory, we should better not be in it
        @tmp = Pathname.new Dir.mktmpdir
      end
      
      context "copy" do

        should "copy one file into another folder" do
          assert_kind_of(CommandResult, result = Cmd.copy(@file1, @subdir))
          assert result.success?
          assert File.exist?(File.join(@subdir, File.basename(@file1)))
        end

        should "copy several files into another folder" do
          assert_kind_of(CommandResult, result = Cmd.copy([@file1, @file2, @file3], @subdir))
          assert result.success?
          [@file1, @file2, @file3].each do |file|
            assert File.exist?(File.join(@subdir, File.basename(file)))
          end
        end
        
        should "know when a source file doesn't exist without die_on_failure" do
          assert_kind_of(CommandResult, result = Cmd.copy('/no/source', @subdir, :die_on_failure => false))
          assert !result.success?
        end
        
        should "know when a source file doesn't exist with die_on_failure" do
          assert_raise(Error::Command::CopyFailed) {
            Cmd.copy('/no/source', @subdir, :die_on_failure => true)
          }
        end
        
        should "know when a destination directory doesn't exist without die_on_failure" do
          assert_kind_of(CommandResult, result = Cmd.copy(@file1, '/no/destination', :die_on_failure => false))
          assert !result.success?
        end
        
        should "know when a destination directory doesn't exist with die_on_failure" do
          assert_raise(Error::Command::CopyFailed) {
            Cmd.copy(@file1, '/no/destination', :die_on_failure => true)
          }
        end
        
      end # context "copy"

      context "move" do

        should "move one file into another folder" do
          assert_kind_of(CommandResult, result = Cmd.move(@file1, @subdir))
          assert result.success?
          assert !File.exist?(@file1)
          assert File.exist?(File.join(@subdir, File.basename(@file1)))
        end

        should "move several files into another folder" do
          assert_kind_of(CommandResult, result = Cmd.move([@file1, @file2, @file3], @subdir))
          assert result.success?
          [@file1, @file2, @file3].each do |file|
            assert !File.exist?(file)
            assert File.exist?(File.join(@subdir, File.basename(file)))
          end
        end
        
        should "know when a source file doesn't exist without die_on_failure" do
          assert_kind_of(CommandResult, result = Cmd.move('/no/source', @subdir, :die_on_failure => false))
          assert !result.success?
        end

        should "know when a source file doesn't exist with die_on_failure" do
          assert_raise(Error::Command::MoveFailed) {
            Cmd.move('/no/source', @subdir, :die_on_failure => true)
          }
        end
        
        should "not mind when a destination doesn't exist even with die_on_failure" do
          assert_kind_of(CommandResult, result = Cmd.move(@file1, File.join(@subdir, 'newfile'), :die_on_failure => true))
          assert result.success?
          assert !File.exist?(@file1)
          assert File.exist?(File.join(@subdir, 'newfile'))
        end
        
      end # context "move"
      
      context "replace" do
      
        setup do
          File.open(@file1, 'w') { |f| assert f.write(DUMMY_TEXT) }
        end

        should "be unsuccessful if the file doesn't exist without die_on_failure" do
          assert_kind_of(CommandResult, result = Cmd.replace('/i/am/not/there', 'FAUST', 'GOETHE', :die_on_failure => false))
          assert !result.success?
        end
        
        should "be unsuccessful if the file doesn't exist with die_on_failure" do
          assert_raise(Error::Command::ReplaceFailed) {
            Cmd.replace('/i/am/not/there', 'FAUST', 'GOETHE')
          }
        end
        
        should "do a simple replacement in a file" do
          assert_kind_of(CommandResult, result = Cmd.replace(@file1, 'FAUST', 'GOETHE'))
          assert result.success?
          assert_equal DUMMY_TEXT.gsub('FAUST', 'GOETHE'), File.read(@file1)
        end
        
        should "do nothing if the file doesnt have anything to replace" do
          assert_kind_of(CommandResult, result = Cmd.replace(@file1, 'ASDF', 'FDSA'))
          assert_equal DUMMY_TEXT, File.read(@file1)
          assert result.success?
        end
        
        should "replace multiple items in one file" do
          Cmd.replace @file1 do |r|
            assert_kind_of(CommandResult, r.replace('FAUST', 'GOETHE'))
            assert_equal DUMMY_TEXT.gsub('FAUST', 'GOETHE'), File.read(@file1)
            assert_kind_of(CommandResult, r.replace("Philosophy,\n", 'Philosophy, '))
            assert File.read(@file1).scan('Philosophy, Medicine')
          end
        end
        
      end # context "replace"
      
    end # context "when working with files"
  
  end # context "As a directory function"
  
  context "run" do
    
    context "in normal mode" do

      setup do
        Options.clear
        Options.testmode = true
        Options.silent = false
      end
    
      should "not produce any output in :internal mode" do
        out, err = capture do
          assert_kind_of(CommandResult, result = Cmd.run('ls', :internal => true))
        end
        assert_equal '', out
        assert_equal '', err
      end
      
      should "produce output in :internal mode" do
        out, err = capture do
          assert_kind_of(CommandResult, result = Cmd.run('ls', :internal => false))
        end
        assert_match /\.+/, out # Make sure it contains only periods
        assert_equal '', err
      end
      
      context "and in reveal mode" do
        
        setup do
          Options.reveal = true
        end

        should "not really execute the command but announce something" do
          out, err = capture do
            assert_kind_of(CommandResult, result = Cmd.run('/this/will//definitely/break/if/executed'))
            assert result.success?
          end
          assert !out.empty?
        end
        
        should "still execute the command if force_in_reveal is true" do
          out, err = capture do
            assert_kind_of(CommandResult, result = Cmd.run('/this/will//definitely/break/if/executed', :die_on_failure => false, :force_in_reveal => true))
            assert !result.success?
          end
          assert !out.empty?
        end
        
      end
      
      context "and in verbose mode" do
        
        setup do
          Options.verbose = true
        end
        
        should "produce verbose output" do
          out, err = capture do
            assert_kind_of(CommandResult, result = Cmd.run('ls', :internal => false))
          end
          assert out.size > 0
          assert_match /[^\.]/, out # Match anything that is not a period
          assert_equal '', err
        end

      end # context "and in verbose mode"
    
    end # context "in normal mode"
    
    context "in silent mode" do
      
      setup do
        Options.clear
        Options.testmode = true
        Options.silent = true
      end
      
      should "return a successfull CommandResult if the command was OK" do
        assert_kind_of(CommandResult, result = Cmd.run('cd'))
        assert_kind_of(Process::Status, result.status)
        assert result.success?
      end
      
      should "not produce any output" do
        out, err = capture do
          assert_kind_of(CommandResult, result = Cmd.run('ls', :internal => false))
        end
        assert_equal '', out
      end
      
      should "return a non-successfull CommandResult if the command was bad without die_on_failure" do
        assert_kind_of(CommandResult, result = Cmd.run('this-command-does-not-exist', :die_on_failure => false))
        assert !result.success?
      end
      
      
    end # context "in silent mode"
    
  end
  
  context "git_clone" do
    
    setup do
      # For some gross reasons the Jeweler::Tasks.new instance modifies the ENV, trying to tell GIT some things
      # that disturb our testing here. We need to undo this here, and it is not a nice solution, but it works.
      ENV.keys.select { |k| k =~ /^GIT_/ }.each { |k| ENV.delete(k) }
      Options.silent = true
      Options.reveal = false
      @tmp = Pathname.new Dir.mktmpdir
      @dir = Pathname.new(File.join(@tmp, 'dummy'))
    end

    teardown do
      assert FileUtils.rm_r(@tmp)
      Dir.chdir '/' # Since we're removing the current directory, we should better not be in it
    end

    should "download a simple git repository" do
      assert_kind_of(CommandResult, result = Cmd.git_clone('a sample git repository', DUMMY_GIT, @dir))
      assert result.success?
      assert @dir.directory?
      assert File.exist?(File.join(@dir, 'dummy.txt'))
    end if ONLINE
    
    should "do nothing at the destination in reveal mode" do
      Options.reveal = true
      assert_kind_of(CommandResult, result = Cmd.git_clone('a sample git repository', DUMMY_GIT, @dir))
      assert result.success?
      assert !@dir.directory?
    end
    
  end

end
