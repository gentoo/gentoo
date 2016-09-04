# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_PNV="${MY_PN}-${PV}"

DESCRIPTION="Build tooling for Clojure"
HOMEPAGE="http://boot-clj.com/"
SRC_URI="https://github.com/boot-clj/${MY_PN}/releases/download/${PV}/${MY_PN}.jar -> ${MY_PNV}.jar"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.7:*"
DEPEND=">=virtual/jdk-1.7:*"

RESTRICT="test"

src_unpack() {
	mkdir -p "${S}" || die "Can't mkdir ${S}"
	cd "${S}"	|| die "Can't enter ${S}"
	for file in ${A}; do
		einfo "Copying ${file}"
		cp "${DISTDIR}/${file}" "${S}/" || die "Can't copy ${file}"
	done
}

src_prepare() {
	einfo "Copying boot shell-script"
	cp "${FILESDIR}/boot" "${S}/" || die "Can't copy boot"

	java-pkg_init_paths_

	sed -i "s|@@JAVA_PKG_SHAREPATH@@|${JAVA_PKG_SHAREPATH}|g" 	"${S}/boot" || die "Can't patch JAVA_PKG_SHAREPATH path in boot"
	sed -i "s|@@JAVA_PKG_JARDEST@@|${JAVA_PKG_JARDEST}|g" 		"${S}/boot" || die "Can't patch JAVA_PKG_JARDEST path in boot"
	sed -i "s|@@PN@@|${PN}|g" 					"${S}/boot" || die "Can't patch PN in boot"

	default
}

src_compile() { :; }

src_install() {
	dobin "${S}/boot"
	java-pkg_newjar "${S}/${MY_PNV}.jar"
}

pkg_postinst() {
	einfo "This package will still download a whole lot of its own runtime"
	einfo "dependencies the first time you run it."
	einfo ""
	einfo "This currently can't be helped and is expected behaviour for a"
	einfo "java based development toolkit"
}
