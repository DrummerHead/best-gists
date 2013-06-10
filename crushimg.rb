#!/usr/bin/ruby

# requires: jpegtran and pngcrush
# brew install libjpeg
# brew install pngcrush
#
# "crushimg" on a directory will look for jpg and png files, compress them using
# jpegtran and pngcrush and return a new file with an "-optimized" suffix.
# it will not traverse the child directories (not recursive)
#
# You can now compare the optimized files with the non optimezed and be happy
#
# Then, if you want to actually replace the non-optimized files with the
# optimized files, run "crushimg --cleanup" to do so.


args = ARGF.argv
d = Dir.new(".")

def compress(dir)
  dir.each do |x|

    name = (/^(.*?)\./.match(x) ? /^(.*?)\./.match(x)[1] : nil)
    ext = (/\.(.*)$/.match(x) ? /\.(.*)$/.match(x)[1] : nil)

    if ext =~ /png/
      mod = " is a PNG, now compressing"
      %x[pngcrush -rem alla -reduce -brute #{x} #{name}-optimized.#{ext}]
    elsif ext =~ /jpg/
      mod = " is a JPG, now compressing"
      %x[jpegtran -copy none -optimize -perfect -progressive -outfile #{name}-optimized.#{ext} #{x}]
    else
      mod = " is not JPG nor PNG, not doing anything"
    end

    puts x + mod
    puts "- - - - - - -"

  end
end

def cleanup(dir)
  dir.each do |x|

    name = (/^(.*?)\./.match(x) ? /^(.*?)\./.match(x)[1] : nil)
    ext = (/\.(.*)$/.match(x) ? /\.(.*)$/.match(x)[1] : nil)
    is_optimized = /-optimized/.match(name)

    if is_optimized
      puts x + " will replace the original file"
      clean_name = /^(.*?)-optimized$/.match(name)[1]
      %x[rm #{clean_name}.#{ext}]
      %x[mv #{name}.#{ext} #{clean_name}.#{ext}]
    end

  end
end

if args.include?("--cleanup")
  puts "'-optimized' files will replace the original files"
  puts "= = = = = = = = = ="
  cleanup(d)
else
  puts "PNG and JPG files will be optimized for smaller size"
  puts "= = = = = = = = = ="
  compress(d)
end
