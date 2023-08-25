#!/bin/sh

set -ex

# Build libmp3lame
wget https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz/download -O lame.tar.gz
tar xf lame.tar.gz
cd lame-3.100
./configure --disable-shared --enable-static --libdir=/lib64
make install
cd /

git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
git checkout n4.4 # Only build stable releases
./configure \
  --disable-everything \
  --disable-doc \
  --enable-static \
  --enable-libmp3lame \
  --enable-gpl \
  --enable-nonfree \
  --enable-decoder=pcm*,flac,mp3,wavpack,aac,mjpeg,png,alac,alac_at,anull \
  --enable-encoder=pcm*,libmp3lame,png,anull,wrapped_avframe \
  --enable-muxer=hls,segment,tee,mp3,ffmetadata,mjpeg,image2,wav,null \
  --enable-demuxer=wav,mp3,mov,aiff,ffmetadata,mjpeg,image2,flac \
  --enable-protocol=file,pipe \
  --enable-filter=aresample,afade,volumedetect,scale
make
