rm -rf zig-out
for target in aarch64-macos aarch64-linux-musl x86_64-macos x86_64-linux-musl
  echo $target
  zig build -Doptimize=ReleaseSmall -Dtarget=$target
  mv zig-out/bin/oblique{,_$target}
end
