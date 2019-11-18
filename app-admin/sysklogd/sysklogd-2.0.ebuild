# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd toolchain-funcs

DESCRIPTION="Standard log daemons"
HOMEPAGE="https://troglobit.com/sysklogd.html https://github.com/troglobit/sysklogd"
SRC_URI="https://github.com/troglobit/sysklogd/releases/download/v$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="klogd logrotate systemd"
RESTRICT="test"

DEPEND=""
RDEPEND=""

DOCS=( ChangeLog.md README.md )

PATCHES=(
	${FILESDIR}/${PN}-2.0-optional_logger.patch
)

pkg_setup() {
	append-lfs-flags
	tc-export CC
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# we have logger from sys-apps/util-linux
		#--without-logger
		$(use_with klogd)
		$(use_with systemd systemd $(systemd_get_systemunitdir))
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc
	doins syslog.conf
	keepdir /etc/syslog.d

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die

	newinitd "${FILESDIR}"/sysklogd.rc8 sysklogd
	newconfd "${FILESDIR}"/sysklogd.confd sysklogd
}
