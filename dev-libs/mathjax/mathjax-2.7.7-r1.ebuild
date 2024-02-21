# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} pypy3 )
inherit python-any-r1

DOCS_COMMIT="9d711f40638202b02f2154d7f05ea35088ff9388"

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="
	https://github.com/mathjax/MathJax/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://github.com/mathjax/MathJax-docs/archive/${DOCS_COMMIT}.tar.gz -> ${PN}-docs-${PV}.tar.gz )
"
S="${WORKDIR}"/MathJax-${PV}
DOCS_S="${WORKDIR}/MathJax-docs-${DOCS_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc examples"

BDEPEND="
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="!app-doc/mathjax-docs"

RESTRICT="binchecks strip"

make_webconf() {
	# web server config file - should we really do this?
	cat > $1 <<-EOF
		Alias /MathJax/ ${EPREFIX}${webinstalldir}/
		Alias /mathjax/ ${EPREFIX}${webinstalldir}/

		<Directory ${EPREFIX}${webinstalldir}>
			Options None
			AllowOverride None
			Order allow,deny
			Allow from all
		</Directory>
	EOF
}

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use doc; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	default
	if use doc; then
		sed -e 's/add_stylesheet/add_css_file/' -i "${DOCS_S}"/conf.py || die
	fi
}

src_compile() {
	if use doc; then
		build_sphinx "${DOCS_S}"
	fi
}

src_install() {
	local DOCS=( README.md )

	default
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins -r test/*
	fi
	rm -r test docs LICENSE README.md || die

	webinstalldir=/usr/share/${PN}
	insinto ${webinstalldir}
	doins -r *

	make_webconf MathJax.conf
	insinto /etc/httpd/conf.d
	doins MathJax.conf
}
