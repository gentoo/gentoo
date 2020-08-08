# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit readme.gentoo-r1 systemd user

DESCRIPTION="Dictionary Client/Server for the DICT protocol"
HOMEPAGE="http://www.dict.org/ https://sourceforge.net/projects/dict/"
SRC_URI="mirror://sourceforge/dict/${P}.tar.gz"

SLOT="0"
# We install rfc so - ISOC-rfc
LICENSE="GPL-2 ISOC-rfc"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="dbi judy minimal test"

# <gawk-3.1.6 makes tests fail.
RDEPEND="
	>=sys-apps/coreutils-6.10
	dev-libs/libmaa
	sys-libs/zlib
	dbi? ( dev-db/libdbi )
	judy? ( dev-libs/judy )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=sys-apps/gawk-3.1.6
	virtual/yacc
	test? ( !~sys-apps/gawk-4.2.1 )
"

DOC_CONTENTS="
	To start and use ${PN} you need to emerge at least one dictionary from
	the app-dicts category with the package name starting with 'dictd-'.
	To install all available dictionaries, emerge app-dicts/dictd-dicts.
	${PN} will NOT start without at least one dictionary.\n
	\nIf you are running systemd, you will need to review the instructions
	explained in /etc/dict/dictd.conf comments.
"
PATCHES=(
	"${FILESDIR}"/dictd-1.10.11-colorit-nopp-fix.patch
	"${FILESDIR}"/dictd-1.12.0-build.patch
)

pkg_setup() {
	enewgroup dictd # used in src_test()
	enewuser dictd -1 -1 -1 dictd
}

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i -e 's:libtool:glibtool:g' Makefile.in || die
	fi
}

src_configure() {
	econf \
		$(use_with dbi plugin-dbi) \
		$(use_with judy plugin-judy) \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/${PN} \
		--sysconfdir="${EPREFIX}"/etc/dict
}

src_compile() {
	if use minimal; then
		emake dictfmt dictzip dictzip
	else
		emake
	fi
}

src_test() {
	use minimal && return 0 # All tests are for dictd which we don't build...
	if [[ ${EUID} -eq 0 ]]; then
		# If dictd is run as root user (-userpriv) it drops its privileges to
		# dictd user and group. Give dictd group write access to test directory.
		chown :dictd "${WORKDIR}" "${S}/test"
		chmod 770 "${WORKDIR}" "${S}/test"
	fi
	emake test
}

src_install() {
	if use minimal; then
		emake DESTDIR="${D}" install.dictzip install.dict install.dictfmt
	else
		default

		dodoc doc/{dicf.ms,rfc.ms,rfc.sh,rfc2229.txt}
		dodoc doc/{security.doc,toc.ms}
		dodoc -r examples

		# conf files. For dict.conf see below.
		insinto /etc/dict
		for f in dictd.conf site.info colorit.conf; do
			doins "${FILESDIR}/1.10.11/${f}"
		done

		# startups for dictd
		newinitd "${FILESDIR}/1.10.11/dictd.initd" dictd
		newconfd "${FILESDIR}/1.10.11/dictd.confd" dictd
		systemd_dounit "${FILESDIR}"/${PN}.service
	fi

	find "${ED}" -name '*.la' -o -name '*.a' -delete || die

	insinto /etc/dict
	doins "${FILESDIR}"/1.10.11/dict.conf

	dodoc ANNOUNCE NEWS README TODO

	readme.gentoo_create_doc
}
