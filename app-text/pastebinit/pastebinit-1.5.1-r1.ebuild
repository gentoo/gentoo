# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"
inherit optfeature python-single-r1

MY_P="${PN}_${PV}"
DESCRIPTION="A software that lets you send anything you want directly to a pastebin"
HOMEPAGE="https://launchpad.net/pastebinit"
SRC_URI="mirror://ubuntu/pool/main/p/${PN}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="man"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/configobj[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	sys-devel/gettext
	man? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"

PATCHES=( "${FILESDIR}"/${P}-distro.patch )

src_prepare() {
	default
	python_fix_shebang "${S}"/${PN}
}

src_compile() {
	emake -C po

	if use man; then
		ebegin "Generating a manpage with xsltproc"
		xsltproc --nonet \
			"${BROOT}"/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl \
			pastebinit.xml
		eend $?
	fi
}

src_install() {
	dobin pastebinit utils/pbput
	dosym pbput /usr/bin/pbget
	dosym pbput /usr/bin/pbputs

	einstalldocs
	doman utils/*.1
	use man && doman pastebinit.1

	insinto /usr/share/locale
	doins -r po/mo/*

	insinto /usr/share
	doins -r pastebin.d
}

pkg_postinst() {
	optfeature "identification of your distribution" dev-python/distro
	optfeature "pbput and pbputs scripts" app-arch/xz-utils
	optfeature "pbget and pbputs scripts" app-crypt/gnupg
}
