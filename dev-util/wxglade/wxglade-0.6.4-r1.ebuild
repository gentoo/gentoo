# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 vcs-snapshot

MY_P="wxGlade-${PV}"

DESCRIPTION="Glade-like GUI designer which can generate Python, Perl, C++ or XRC code"
HOMEPAGE="https://bitbucket.org/agriggio/wxglade"
SRC_URI="https://bitbucket.org/agriggio/wxglade/get/rel_${PV}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
        dev-python/wxpython:2.8[${PYTHON_USEDEP}]"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	epatch "${FILESDIR}"/${P}-wxversion.patch
}

src_compile() {
	:
}

src_install() {
	dodoc CHANGES.txt README.txt TODO.txt
	newicon icons/icon.xpm wxglade.xpm
	#|| die "installing wxglade.xpm failed"
	doman "${S}"/debian/wxglade.1
	#|| die "installing man failed"
	rm -rf "${S}"/debian
	dohtml -r "${S}"/docs/*
	#|| die "installing docs failied"
	rm -rf "${S}"/docs

	python_copy_sources

	installation() {
		pydir=$(python_get_sitedir)/${PN}
		insinto "${pydir}"
		doins "${S}"/credits.txt
		#|| die "installing credits.txt failed"
		doins -r ./*
		#|| die "installing failed"
		dosym /usr/share/doc/${PF}/html "${pydir}"/docs
		#|| die "doc symlink failed"
		fperms 775 "${pydir}"/wxglade.py
		dosym "${pydir}"/wxglade.py /usr/bin/wxglade-$(python_get_version)
		#\ || die "main symlink failed"
	}
	python_execute_function -s installation

	python_generate_wrapper_scripts -E -f -q "${D}"usr/bin/wxglade

	make_desktop_entry wxglade wxGlade wxglade "Development;GUIDesigner"
}

pkg_postinst() {
	python_mod_optimize wxglade
}

pkg_postrm() {
	python_mod_cleanup wxglade
}
