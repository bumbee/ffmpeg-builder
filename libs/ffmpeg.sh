ffmpeg_dependencies() {
	eval $1="'$FF_LIBS'"
}

ffmpeg_fetch() {
	#do_git_checkout https://github.com/FFmpeg/FFmpeg.git $1
	download_and_extract http://ffmpeg.org/releases/ffmpeg-3.4.5.tar.bz2 $1
}

ffmpeg_clean() {
	make distclean
}

ffmpeg_set_params() {
	local __resultvar=$1
	local options=$2

	# Make enabled libraries unique.
	FF_ENABLED_LIBS=$(echo "$FF_ENABLED_LIBS" | tr ' ' '\n' | sort -u)

	add_prefix params "--arch=$ARCH \
		--pkg-config=pkg-config \
		--pkg-config-flags=--static \
		--disable-ffserver \
		--disable-doc \
		--disable-static \
		--enable-shared \
		--enable-gpl \
		--enable-version3 \
		--enable-postproc \
		--enable-runtime-cpudetect \
		--enable-pic \
		$options \
		$FF_ENABLED_LIBS"

	eval $__resultvar='$params'
}

ffmpeg_set_pthreads() {
	eval $1='"$2 --disable-w32threads --enable-pthreads"'
}

ffmpeg_configure_darwin() {
	ffmpeg_set_params config "--target-os=darwin"
	ffmpeg_set_pthreads config "$config"

	./configure $config
}

ffmpeg_configure_linux32() {
	ffmpeg_set_params config "--target-os=linux --enable-cross-compile --extra-ldflags=-ldl"
	ffmpeg_set_pthreads config "$config"

	./configure $config
}

ffmpeg_configure_linux64() {
	ffmpeg_set_params config "--target-os=linux"
	ffmpeg_set_pthreads config "$config"

	./configure $config
}

ffmpeg_configure_mingw() {
	ffmpeg_set_params config "--target-os=mingw32 --cross-prefix=$TOOL_CHAIN_PREFIX --enable-dxva2"
	ffmpeg_set_pthreads config "$config"

	LDFLAGS="$LDFLAGS -static -static-libgcc -static-libstdc++" ./configure $config
}

ffmpeg_configure_win() {
	ffmpeg_set_params config "--target-os=$TARGET_OS --arch=$ARCH --toolchain=$TOOLCHAIN --extra-cflags=$CPPFLAGS --extra-ldflags=$LDFLAGS"

	./configure $config
}

ffmpeg_make() {
	make
}

ffmpeg_install() {
	make install
}

ffmpeg_enable() {
	:
}
