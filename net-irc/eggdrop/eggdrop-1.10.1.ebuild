# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )

inherit readme.gentoo-r1 python-single-r1

MY_P="${PN}-${PV/_rc/rc}"
DESCRIPTION="An IRC bot extensible with C or TCL"
HOMEPAGE="https://www.eggheads.org/"
SRC_URI="https://ftp.eggheads.org/pub/eggdrop/source/$(ver_cut 1-2)/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~riscv ~sparc ~x86"
IUSE="debug doc python ssl static"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	dev-lang/tcl:0=
	virtual/zlib:=
	python? ( ${PYTHON_DEPS} )
	ssl? ( dev-libs/openssl:0= )
"
RDEPEND="
	sys-apps/gentoo-functions
	${DEPEND}
"

DOCS=( AUTHORS FEATURES INSTALL NEWS README THANKS UPGRADING )

PATCHES=(
	"${FILESDIR}"/${P}-lto.patch
)

src_configure() {
	if ! use python; then
		export egg_enable_python=no
	fi

	econf --enable-ipv6 \
		$(use_enable ssl tls)

	emake config
}

src_compile() {
	local target

	if use static && use debug; then
		target="sdebug"
	elif use static; then
		target="static"
	elif use debug; then
		target="debug"
	fi

	emake ${target}
}

src_install() {
	emake DEST="${ED}"/opt/eggdrop install

	use doc && HTML_DOCS=( doc/html/. )
	rm -r "${ED}"/opt/eggdrop/doc/html || die
	DOC_CONTENTS="
		Additional documentation can be found
		in ${EPREFIX}/opt/eggdrop/doc
	"
	readme.gentoo_create_doc
	einstalldocs

	dobin "${FILESDIR}"/eggdrop-installer
	doman doc/man1/eggdrop.1
}

pkg_postinst() {
	# Only display this for new installs
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Please run ${EPREFIX}/usr/bin/eggdrop-installer to install your eggdrop bot."
	fi
}
