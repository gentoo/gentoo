# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_ANT_ENCODING=UTF-8

ESVN_REPO_URI="https://josm.openstreetmap.de/svn/trunk"
inherit eutils java-pkg-2 java-ant-2 subversion desktop

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="https://josm.openstreetmap.de/"
[[ ${PV} == "99999" ]] || ESVN_REPO_URI="${ESVN_REPO_URI}@${PV}"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

IUSE=""
RESTRICT="network-sandbox"

src_prepare() {
	default
	# create-revision needs the compile directory to be a svn directory
	# see also https://lists.openstreetmap.org/pipermail/dev/2009-March/014182.html
	sed -i \
		-e "s:arg[ ]value=\".\":arg value=\"${ESVN_STORE_DIR}\/${PN}\/trunk\":" \
		build.xml || die "Sed failed"
	mkdir -p "${S}/.svn"
}

src_compile() {
	eant dist-optimized
}

src_install() {
	java-pkg_newjar "dist/${PN}-custom-optimized.jar" "${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	local icon_size
	for icon_size in 16 32 48; do
		newicon -s "${icon_size}" -t "hicolor" \
			"build/images/logo_${icon_size}x${icon_size}x32.png" ${PN}.png
		newicon -s "${icon_size}" -t "locolor" \
			"build/images/logo_${icon_size}x${icon_size}x8.png" ${PN}.png
	done
	make_desktop_entry "${PN}" "Java OpenStreetMap Editor" ${PN} "Utility;Science;Geoscience"
}
