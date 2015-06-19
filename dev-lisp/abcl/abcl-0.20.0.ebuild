# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/abcl/abcl-0.20.0.ebuild,v 1.4 2015/05/23 15:14:30 pacho Exp $

EAPI="2"

inherit java-pkg-2 java-ant-2

MY_P=${PN}-src-${PV}

DESCRIPTION="Armed Bear Common Lisp is a Common Lisp implementation for the JVM"
HOMEPAGE="http://common-lisp.net/project/armedbear/"
SRC_URI="http://common-lisp.net/project/armedbear/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="jad"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5
	jad? ( dev-java/jad-bin )"

S="${WORKDIR}"/${MY_P}

src_compile() {
	eant abcl.compile || die "Can't compile ABCL"
	eant abcl.jar || die "Can't make ABCL jar archive"
}

src_install() {
	java-pkg_dojar dist/abcl.jar
	java-pkg_dolauncher ${PN} --java_args "-server -Xrs" --main org.armedbear.lisp.Main
	dodoc README || die "Can't install README"
}
