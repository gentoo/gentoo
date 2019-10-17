# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="fast, low complexity waveform coder (i.e. audio compressor)"
HOMEPAGE="http://shnutils.freeshell.org/shorten/"
SRC_URI="http://shnutils.freeshell.org/shorten/dist/src/${P}.tar.gz"

LICENSE="shorten"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc sparc x86"

PATCHES=( "${FILESDIR}"/${PN}-tests.patch )
