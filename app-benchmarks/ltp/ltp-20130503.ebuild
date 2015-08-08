# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils readme.gentoo

MY_PN="${PN}-full"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A testsuite for the linux kernel"
HOMEPAGE="http://ltp.sourceforge.net/"
SRC_URI="mirror://sourceforge/ltp/LTP%20Source/${P}/${MY_P}.bz2 -> ${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="expect perl pm open-posix python rt"

DEPEND="expect? ( dev-tcltk/expect )
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )"

RESTRICT="test"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	# Don't create groups
	export CREATE=0

	DOC_CONTENTS="LTP requires root access to run the tests.
		The LTP root directory is located in /opt/${PN}.
		For more information please read the ltp-howto located in
		/usr/share/doc/${PF}"
}

src_prepare() {
	# regenerate
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# FIXME: improve me
	local myconf=
	use open-posix && myconf+="--with-open-posix-testsuite "
	use pm && mytconf+="--with-power-management-testsuite "
	use rt && myconf+="--with-realtime-testsuite "
	use perl && myconf+="--with-perl "
	use python && myconf+="--with-python "
	use expect && myconf+="--with-expect "

	# Better put it into /opt/${PN} as everything needs to
	# be under the same directory..

	econf --prefix=/opt/${PN} ${myconf}
}

src_compile() {
	# Posix testsuite does not seem to build with -j>1
	# Is this maintained anymore?
	if use open-posix; then
		export MAKEOPTS="-j1"
	fi
	emake
}

src_install() {
	default
	dosym /usr/libexec/${PN}/runltp /usr/bin/runltp
	# install docs
	dodoc doc/MaintNotes
	for txt in doc/*.txt; do
		dodoc ${txt}
	done
	dodoc -r doc/examples doc/testcases
	dohtml -r doc/automation-*.html
	doman doc/man1/*.1
	doman doc/man3/*.3
	readme.gentoo_create_doc
}
