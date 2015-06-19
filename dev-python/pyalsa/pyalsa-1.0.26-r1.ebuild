# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyalsa/pyalsa-1.0.26-r1.ebuild,v 1.8 2015/04/08 08:05:28 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python bindings for ALSA library"
HOMEPAGE="http://alsa-project.org/"
SRC_URI="mirror://alsaproject/pyalsa/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-1.0.25-no-build-symlinks.patch"
	)

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# note: this needs changing when py3 becomes supported
	append-flags -fno-strict-aliasing
}
