# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools git-2 python-single-r1

DESCRIPTION="GSM receiver block from the airprobe suite"
HOMEPAGE="https://svn.berlin.ccc.de/projects/airprobe/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	net-libs/libosmocore
	>=net-wireless/gnuradio-3.7_rc:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

EGIT_REPO_URI="git://git.gnumonks.org/airprobe.git"
EGIT_SOURCEDIR="${S}"
S+=/${PN}

src_prepare() {
	epatch "${FILESDIR}"/0001-${PN}-build-against-gnuradio-3.7.patch
	python_fix_shebang "${S}"
	eautoreconf
}

src_configure() {
	# fails to create .deps directory without dependency tracking
	econf --enable-dependency-tracking
}

src_install() {
	default

	dobin src/python/*.py
	insinto /usr/share/doc/${PF}/examples
	doins src/python/*.sh
}
