# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

MY_P="${PN}-${PV/_rc/rc}"
DESCRIPTION="An IRC bot extensible with C or TCL"
HOMEPAGE="https://www.eggheads.org/"
SRC_URI="https://ftp.eggheads.org/pub/eggdrop/source/${PV:0:3}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~riscv ~sparc ~x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="debug doc ipv6 ssl static"

DEPEND="
	dev-lang/tcl:0=
	ssl? ( dev-libs/openssl:0= )
"
RDEPEND="
	sys-apps/gentoo-functions
	${DEPEND}
"

DOCS=( AUTHORS FEATURES INSTALL NEWS README THANKS UPGRADING )

src_configure() {
	econf $(use_enable ssl tls) \
		$(use_enable ipv6 ipv6)

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
	emake DEST="${D}"/opt/eggdrop install

	use doc && HTML_DOCS=( doc/html/. )
	rm -r "${D}"/opt/eggdrop/doc/html || die
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
