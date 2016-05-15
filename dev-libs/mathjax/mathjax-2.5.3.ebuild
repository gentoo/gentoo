# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="http://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RESTRICT="binchecks strip"

S=${WORKDIR}/MathJax-${PV}

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
	egit_clean
}

src_install() {
	dodoc README*
	use doc && dohtml -r docs/html/*
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins -r test/*
	fi
	rm -r test docs LICENSE README* || die

	webinstalldir=/usr/share/${PN}
	insinto ${webinstalldir}
	doins -r *

	make_webconf MathJax.conf
	insinto /etc/httpd/conf.d
	doins MathJax.conf
}
