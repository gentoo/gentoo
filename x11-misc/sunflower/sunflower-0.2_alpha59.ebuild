# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit gnome2-utils python-r1 xdg-utils

MY_PN="Sunflower"
DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://github.com/MeanEYE/Sunflower
	http://sunflower-fm.org/"
SRC_URI="http://sunflower-fm.org/pub/sunflower-${PV/_alpha/-}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/notify-python-0.1[${PYTHON_USEDEP}]
	gnome-base/librsvg:2"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	default
	find "${S}" -name "*.py[co]" -delete || die
	find "${S}"/translations -name "*.po" -delete || die
	rm "${S}"/translations/${PN}.pot || die

	sed -i \
		-e '/^application_file/s/os.path.dirname(sys.argv\[0\])/os.getcwd()/' \
		${MY_PN}.py || die
}

src_install() {
	touch __init__.py || die
	installme() {
		# install modules
		python_moduleinto ${PN}
		python_domodule images application ${MY_PN}.py \
			AUTHORS CHANGES COPYING DEPENDS TODO __init__.py

		# generate and install startup scripts
		sed \
			-e "s#@SITEDIR@#$(python_get_sitedir)/${PN}#" \
			"${FILESDIR}"/${PN} > "${WORKDIR}"/${PN} || die
		python_doscript "${WORKDIR}"/${PN}
	}

	# install for all enabled implementations
	python_foreach_impl installme

	insinto /usr/share/locale
	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd "${S}"/translations ; echo *) ; do
			if has ${i} ${LINGUAS} ; then
				doins -r "${S}"/translations/${i}
			fi
		done
	else
		doins -r "${S}"/translations/*
	fi

	newicon -s 64 images/${PN}_64.png ${PN}.png
	doicon -s scalable images/${PN}.svg
	newmenu ${MY_PN}.desktop ${PN}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	# TODO: better description
	elog "optional dependencies:"
	elog "  dev-python/libgnome-python"
	elog "  media-libs/mutagen"
	elog "  x11-libs/vte:0[python] (terminal support)"
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
