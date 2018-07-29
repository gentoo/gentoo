# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit desktop gnome2-utils python-r1 xdg-utils

MY_PN="Sunflower"
DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://gitlab.com/MeanEYE/Sunflower
	http://sunflower-fm.org/"
SRC_URI="http://sunflower-fm.org/pub/sunflower-0.3-61.tgz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/notify-python-0.1[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	gnome-base/librsvg:2"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	default
	find translations -name "*.po" -delete || die
	rm translations/${PN}.pot || die

	sed -i \
		-e '/^application_file/s/os.path.dirname(sys.argv\[0\])/os.getcwd()/' \
		${MY_PN}.py || die
}

src_install() {
	touch __init__.py || die
	installme() {
		# install modules
		python_moduleinto ${PN}
		python_domodule __init__.py application images ${MY_PN}.py

		# generate and install startup scripts
		sed \
			-e "s#@SITEDIR@#$(python_get_sitedir)/${PN}#" \
			"${FILESDIR}"/${PN} > "${WORKDIR}"/${PN} || die
		python_doscript "${WORKDIR}"/${PN}
	}

	# install for all enabled implementations
	python_foreach_impl installme

	insinto /usr/share/locale
	doins -r "${S}"/translations/*

	newicon -s 64 images/${PN}_64.png ${PN}.png
	doicon -s scalable images/${PN}.svg
	newmenu ${MY_PN}.desktop ${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	echo
	ewarn "You might also want to install some optional dependencies:"
	elog "  dev-python/libgnome-python"
	elog "  dev-python/setproctitle"
	elog "  media-libs/mutagen"
	elog "  x11-libs/vte:0[python]  # terminal support"
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
