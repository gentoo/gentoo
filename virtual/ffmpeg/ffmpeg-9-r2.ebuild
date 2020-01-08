# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual package for FFmpeg executable implementation"

# Please note that this virtual is only suited for packages that call
# ffmpeg/avconv or one of the remaining executables. If your package
# links to one of the libraries, you need to use the following
# dependency instead (adding IUSE=libav):
#	libav? ( media-video/libav:0= )
#	!libav? ( media-video/ffmpeg:0= )

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="X +encode gsm jpeg2k libav mp3 opus sdl speex theora threads truetype vaapi vdpau x264"

RDEPEND="
	libav? ( >=media-video/libav-9.12[X?,encode?,gsm?,jpeg2k?,mp3?,opus?,sdl?,speex?,theora?,threads?,truetype?,vaapi?,vdpau?,x264?] )
	!libav? ( >=media-video/ffmpeg-1.2.6-r1:0[X?,encode?,gsm?,jpeg2k?,mp3?,opus?,sdl?,speex?,theora?,threads?,truetype?,vaapi?,vdpau?,x264?] )
"
