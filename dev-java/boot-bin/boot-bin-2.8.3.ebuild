# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_PNV="${MY_PN}-${PV}"
GITHUB_USER="boot-clj"

DESCRIPTION="Build tooling for Clojure"
HOMEPAGE="https://boot-clj.com/"
SRC_URI="
	https://github.com/${GITHUB_USER}/${MY_PN}/releases/download/${PV}/${MY_PN}.jar -> ${MY_PNV}.jar
	https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${PV}/README.md -> ${MY_PNV}-README.md
	https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${PV}/CHANGES.md -> ${MY_PNV}-CHANGES.md
"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7"

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

	for file in "README.md" "CHANGES.md"; do
		einfo "Renaming ${MY_PNV}-${file} to ${file}"
		mv "${S}/${MY_PNV}-${file}" "${S}/${file}" || die "Can't rename ${MY_PNV}-${file} to ${file}"
	done

	java-pkg_init_paths_

	sed -i "s|@@JAVA_PKG_SHAREPATH@@|${JAVA_PKG_SHAREPATH}|g" "${S}/boot" || die "Can't patch JAVA_PKG_SHAREPATH path in boot"
	sed -i "s|@@JAVA_PKG_JARDEST@@|${JAVA_PKG_JARDEST}|g" "${S}/boot" || die "Can't patch JAVA_PKG_JARDEST path in boot"
	sed -i "s|@@PN@@|${PN}|g" "${S}/boot" || die "Can't patch PN in boot"

	default
}

src_compile() { :; }

src_install() {
	dobin "${S}/boot"
	dodoc "${S}/README.md"
	dodoc "${S}/CHANGES.md"

	java-pkg_newjar "${S}/${MY_PNV}.jar"
}

pkg_postinst() {
	einfo "This package will still download a whole lot of its own runtime"
	einfo "dependencies the first time you run it."
	einfo ""
	einfo "This currently can't be helped and is expected behaviour for a"
	einfo "java based development toolkit"
	einfo ""
	einfo "You may also need to nuke ~/.boot/boot.properties to get the"
	einfo "updated mechanics, and for boot --version to behave correctly"
	einfo "due to upstreams per-user/per-project version-locking mechanisms"
}
