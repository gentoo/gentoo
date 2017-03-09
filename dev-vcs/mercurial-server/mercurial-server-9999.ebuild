# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# force single impl to avoid python-exec wrapping
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 user

if [[ "${PV}" = "9999" ]]; then
	inherit mercurial
	EHG_REPO_URI="http://hg.opensource.lshift.net/mercurial-server"
	KEYWORDS=""
else
	MY_P="${PN}_${PV}"
	SRC_URI="http://dev.lshift.net/paul/mercurial-server/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Mercurial authentication and authorization tools"
HOMEPAGE="http://www.lshift.net/mercurial-server.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="dev-vcs/mercurial"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

pkg_setup() {
	enewgroup hg
	enewuser hg -1 /bin/bash "/var/lib/${PN}" hg
	python-single-r1_pkg_setup
}

python_prepare_all() {
	# remove useless makefile
	rm Makefile || die

	# fix installation paths
	sed -i -e "s|'init'|'share/${PN}/init'|" setup.py \
		|| die 'sed setup.py failed.'

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# build documentation
	if use doc; then
		xsltproc --nonet -o manual.html \
			/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl \
			doc/manual.docbook || die "xsltproc failed"
	fi
}

python_install() {
	distutils-r1_python_install --install-scripts="/usr/share/${PN}"
}

python_install_all() {
	distutils-r1_python_install_all

	# install configuration files
	insinto "/etc/${PN}"
	doins -r src/init/conf/.
	keepdir /etc/mercurial-server/keys/{root,users}

	# install documentation
	use doc && dodoc manual.html

	# install hg home directory
	keepdir "/var/lib/${PN}"
	fowners hg:hg "/var/lib/${PN}"
	fperms 750 "/var/lib/${PN}"
}
