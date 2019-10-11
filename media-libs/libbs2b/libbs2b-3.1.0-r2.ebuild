# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Bauer stereophonic-to-binaural DSP library"
HOMEPAGE="http://bs2b.sourceforge.net/"
SRC_URI="mirror://sourceforge/bs2b/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libsndfile-1.0.25-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# for default_src_configure to work
ECONF_SOURCE="${S}"

PATCHES=( "${FILESDIR}/${PV}-format-security.patch" )
