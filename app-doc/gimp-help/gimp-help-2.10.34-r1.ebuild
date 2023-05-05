# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="https://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-libs/libxml2[python,${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd
	dev-lang/perl
	dev-libs/libxslt
	gnome-base/librsvg
	sys-devel/gettext
"

DOCS=( AUTHORS COPYING NEWS README )

python_check_deps() {
	python_has_version "dev-libs/libxml2[python,${PYTHON_USEDEP}]"
}

pkg_setup() {
	# See bug: 891709
	if [[ -z "${LINGUAS}" ]] ; then
		export LINGUAS="en"

		ewarn "The 'LINGUAS' environment variable isn't setup in '/etc/portage/make.conf',"
		ewarn "therefore only the generic ('en') documentation will be built."
		ewarn "To build ${PN} for other languages please setup 'LINGUAS' variable"
		ewarn "or assign it to 'L10N' variable if available, i.e. LINGUAS=\"\${L10N}\""
		ewarn "The following languages are supported for ${PN}:"
		ewarn "'ca cs da de el en en_GB es fa fi fr hr hu it ja ko lt nl nn pt pt_BR ro ru sl sv uk zh_CN'"
		ewarn "For more details please read:"
		ewarn "https://wiki.gentoo.org/wiki/Localization/Guide#LINGUAS"
	fi
}

src_configure() {
	econf --without-gimp
}

src_compile() {
	# See bug: 833566
	python_export_utf8_locale
	# Affected with bugs: 677198, 876205. Set "emake -j1"
	emake -j1
}

src_install() {
	# See bug: 905693
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
