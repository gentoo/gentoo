# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils readme.gentoo

DESCRIPTION="A testsuite for the linux kernel"
HOMEPAGE="http://linux-test-project.github.io/"
SRC_URI="https://github.com/linux-test-project/ltp/archive/20150119.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="expect perl pm open-posix python rt"

DEPEND="expect? ( dev-tcltk/expect )
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )"

RESTRICT="test"

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
	# Prevent any kernel stuff for now as it leads to sandbox violations
	myconf+="--without-modules --with-linux-dir=/dev/null"

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
	dodoc -r doc/testcases
	dohtml -r doc/automation-*.html
	doman doc/man1/*.1
	doman doc/man3/*.3
	readme.gentoo_create_doc
}
