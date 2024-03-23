# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-any-r1

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="https://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2+"
SLOT="2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="nls"

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
	python-any-r1_pkg_setup

	# The upstream build system isn't pure gettext and doesn't distinguish
	# between empty and unset LINGUAS. Default to English only if either
	# nls is unset or if LINGUAS exists but is empty. #891709
	if ! use nls || [[ -v LINGUAS && -z ${LINGUAS} ]]; then
		export LINGUAS="en"
	elif [[ ! -v LINGUAS ]]; then
		local line
		while read line; do ewarn "${line}"; done <<-EOF
			The "LINGUAS" variable is unset in your configuration,
			but the "nls" USE flag is set. Therefore, documentation for
			*all* languages will be built, which may take quite some time.
			If you want to install documentation for a defined list
			of languages, please assign "LINGUAS" accordingly.
			The following languages are supported for ${CATEGORY}/${PN}:
			"ca cs da de el en en_GB es fa fi fr hr hu it ja ko lt nl nn
			pt pt_BR ro ru sl sv uk zh_CN"
			If you want to install only the English documentation, it is
			recommended to unset the "nls" USE flag for ${CATEGORY}/${PN}.

			For more details please read:
			https://wiki.gentoo.org/wiki/Localization/Guide#LINGUAS
		EOF
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

src_test() {
	emake -j1 check
}

src_install() {
	# See bug: 905693
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
