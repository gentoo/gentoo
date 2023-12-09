# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="A meta package for realtime MPEG 1.0/2.0/2.5 audio player for layers 1, 2 and 3"
HOMEPAGE="https://www.mpg123.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="alsa coreaudio jack nas oss portaudio pulseaudio sdl"

RDEPEND="
	media-sound/mpg123-base[${MULTILIB_USEDEP},alsa?,coreaudio?,jack?,nas?,oss?,portaudio?,pulseaudio?,sdl?]
	media-plugins/mpg123-output-plugins[alsa?,coreaudio?,jack?,nas?,oss?,portaudio?,pulseaudio?,sdl?]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
