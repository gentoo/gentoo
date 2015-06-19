# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/hammer/hammer-9999.ebuild,v 1.2 2014/05/14 20:51:58 lejonet Exp $

EAPI="5"
# Hammer upstreams only supports python2.7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL="true"
DISTUTILS_SINGLE_IMPL="true"

inherit eutils toolchain-funcs scons-utils git-2 distutils-r1

DESCRIPTION="Hammer is a parsing library, which is bit-oriented and features several parsing backends"
HOMEPAGE="https://github.com/UpstandingHackers/hammer"
SRC_URI=""
EGIT_REPO_URI="git://github.com/UpstandingHackers/hammer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug perl php python test"

DEPEND="dev-util/scons
>=dev-libs/glib-2.29
python? ( ${PYTHON_DEPS}
dev-lang/swig )
perl? ( >=dev-lang/swig-2.0.8 )
php? ( dev-lang/swig )"
RDEPEND=""
src_prepare() {
	tc-export AR CC CXX RANLIB
}

src_configure() {
	myesconsargs="bindings=cpp"

	if use python; then
		myesconsargs+=",python"
	fi

	if use perl; then
		myesconsargs+=",perl"
	fi

	if use debug; then
		# Has to be before bindings parameter
		# or else it whines about bogus bindings
		myesconsarg+="--variant=debug ${myesconsarg}"
	fi
}

src_compile() {
	escons prefix="/usr"

	# Have to replace /usr/local in the Makefile for
	# the perl binding because it doesn't inherit/honor the
	# prefix set at scons commandline
	if use perl; then
		sed -i s:/usr/local:/usr: "${S}/build/opt/src/bindings/perl/Makefile"
	fi
}

src_test() {
	escons test
}

src_install() {
	escons prefix="${D}/usr" install
	dodoc -r README.md NOTES HACKING TODO examples/

}
