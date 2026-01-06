# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

MY_PN=${PN%-*}

DESCRIPTION="Free universal database tool (community edition)"
HOMEPAGE="https://dbeaver.io/"
SRC_URI="
	amd64? ( https://dbeaver.io/files/${PV}/dbeaver-ce-${PV}-linux.gtk.x86_64.tar.gz )
	arm64? ( https://dbeaver.io/files/${PV}/dbeaver-ce-${PV}-linux.gtk.aarch64.tar.gz )
"
S=${WORKDIR}/${MY_PN}

LICENSE="Apache-2.0 EPL-1.0 BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RDEPEND="
	>=virtual/jre-21:*
	x11-libs/gtk+:3[wayland]
"

QA_PREBUILT="
	opt/${MY_PN}-ce.*
"

src_prepare() {
	sed -e "s/^Icon=.*/Icon=${MY_PN}/" \
		-e 's:/usr/share/dbeaver:/opt/dbeaver:g' \
		-e "s:^Exec=.*:Exec=${EPREFIX}/usr/bin/${MY_PN}:" \
		-i "${MY_PN}-ce.desktop" || die
	default
}

src_configure() {
	# Remove JRE bundled
	rm -r "${S}/jre" || die
	# Remove unused plugins for other platforms
	local JNA_DIR="${S}/plugins/com.sun.jna_5.18.1.v20251001-0800/com/sun/jna"
	pushd "${JNA_DIR}" || die
	for i in *-*; do
		use amd64 && [[ ${i} == linux-x86-64 ]] && continue
		use arm64 && [[ ${i} == linux-aarch64 ]] && continue
		rm -rv "${JNA_DIR}/${i}" || die
	done
	popd || die
}

src_install() {
	doicon -s 128 "${MY_PN}.png"
	newicon icon.xpm "${MY_PN}.xpm"
	domenu "${MY_PN}-ce.desktop"

	local DOCS=( readme.txt )
	einstalldocs

	rm -vf "${MY_PN}-ce.desktop" "${MY_PN}.png" icon.xpm readme.txt || die
	insinto "/opt/${MY_PN}-ce"
	doins -r ./*
	fperms 755 "/opt/${MY_PN}-ce/${MY_PN}"

	make_wrapper "${MY_PN}" "/opt/${MY_PN}-ce/${MY_PN}" "/opt/${MY_PN}-ce"
}
