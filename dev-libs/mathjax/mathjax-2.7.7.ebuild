# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-clean

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/MathJax-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc examples"

RDEPEND="doc? ( app-doc/mathjax-docs:${SLOT} )"

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

src_prepare() {
	default
	egit_clean
}

src_install() {
	local DOCS=( README.md )
	if use doc; then
		dodir /usr/share/doc/${P}
		dosym ../${PN}-docs-${SLOT}/html /usr/share/doc/${P}/html
	fi

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
