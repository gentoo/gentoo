# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

MY_PN="calamares"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{11..13} )

inherit desktop python-single-r1

DESCRIPTION="Gentoo Linux ${MY_PN} installer config"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/gentoo-artwork-livecd-2007.0.tar.bz2
		mirror://gentoo/gentoo-artwork-0.2.tar.bz2"

S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
DEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject:3
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf
	x11-libs/pango
"
RDEPEND="${DEPEND}
		>=app-admin/calamares-3.3.14-r2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default

	local baselayout_version
	baselayout_version=$(best_version sys-apps/baselayout)
	baselayout_version=${baselayout_version#*layout-}

	cp "${FILESDIR}/artwork/branding.desc" "${WORKDIR}/branding.desc" || die

	if [[ -n ${baselayout_version} ]]; then
		sed -i "s|GENTOO_VERSION|${baselayout_version}|g" "${WORKDIR}/branding.desc" || die
	fi
}

src_install() {
	insinto "/etc/${MY_PN}"
	doins -r "${FILESDIR}"/settings.conf

	insinto "/etc/${MY_PN}/modules"
	for conf_file in "${FILESDIR}"/modules/*.conf; do
		newins "${conf_file}" "$(basename "${conf_file}")"
	done

	insinto /usr/$(get_libdir)/calamares/modules/
	doins -r "${FILESDIR}"/modules/downloadstage3
	doins -r "${FILESDIR}"/modules/dracut_gentoo

	domenu "${FILESDIR}"/gentoo-installer.desktop

	insinto /usr/bin/
	dobin "${FILESDIR}/${MY_PN}-pkexec"

	insinto /usr/share/icons/calamares-gentoo/64x64/
	newins gentoo-artwork-0.2/icons/gentoo/64x64/gentoo.png gentoo.png

	insinto /etc/calamares/branding/gentoo_branding
	doins -r "${FILESDIR}"/artwork/show.qml
	doins -r "${WORKDIR}"/branding.desc

	local i
	for i in {1..10}; do
		newins gentoo-livecd-2007.0/800x600.png "${i}.png"
	done
	newins gentoo-artwork-0.2/icons/gentoo/64x64/gentoo.png gentoo.png
	newins gentoo-livecd-2007.0/800x600.png languages.png
}
