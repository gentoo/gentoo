# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite,threads(+)"

inherit meson python-single-r1 optfeature virtualx xdg

DESCRIPTION="An open source gaming platform for GNU/Linux"
HOMEPAGE="https://lutris.net/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/lutris/lutris.git"
	inherit git-r3
else
	if [[ ${PV} == *_beta* ]] ; then
		SRC_URI="https://github.com/lutris/lutris/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}"/${P/_/-}
	else
		SRC_URI="https://lutris.net/releases/${P/-/_}.tar.xz"
		S="${WORKDIR}/${PN}"
		KEYWORDS="~amd64 ~x86"
	fi
fi

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pypresence[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/moddb[${PYTHON_USEDEP}]
	')
	media-sound/fluid-soundfont
	|| (
		net-libs/webkit-gtk:4[introspection]
		net-libs/webkit-gtk:4.1[introspection]
	)
	sys-apps/xdg-desktop-portal
	x11-apps/mesa-progs
	x11-apps/xgamma
	x11-apps/xrandr
	x11-libs/gtk+:3[introspection]
	x11-libs/gdk-pixbuf[jpeg]
"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

DOCS=( AUTHORS README.rst docs/installers.rst docs/steam.rst )

PATCHES=(
	"${FILESDIR}/${P}-find-eselected-wine.patch"
)

src_test() {
	virtx epytest
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/share/lutris/bin/lutris-wrapper" #740048
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "running MS Windows games through wine+DXVK/proton or other Vulkan games (plus ICD for your hardware)" "media-libs/vulkan-loader dev-util/vulkan-tools"

	# Quote README.rst
	elog ""
	elog "Lutris installations are fully automated through scripts, which can"
	elog "be written in either JSON or YAML. The scripting syntax is described"
	elog "in ${EROOT}/usr/share/doc/${PF}/installers.rst.bz2, and is also"
	elog "available online at lutris.net."
}
