# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-r1 xdg-utils desktop

MY_PN="${PN^}"
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="Small and highly customizable twin-panel file manager with plugin-support"
HOMEPAGE="https://github.com/MeanEYE/Sunflower
	http://sunflower-fm.org/"
SRC_URI="https://github.com/MeanEYE/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.15.0:2[${PYTHON_USEDEP}]
	>=dev-python/notify-python-0.1[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_PN}-$MY_PV

src_prepare() {
	default
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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	# TODO: better description
	elog "optional dependencies:"
	elog "  dev-python/libgnome-python"
	elog "  media-libs/mutagen"
	elog "  x11-libs/vte:0[python] (terminal support)"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
