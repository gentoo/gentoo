# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="HTTP AntiVirus Proxy"
HOMEPAGE="http://www.havp.org/"
SRC_URI="http://www.server-side.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="clamav ssl"

DEPEND="clamav? ( >=app-antivirus/clamav-0.98.5 )"
RDEPEND="
	${DEPEND}
	acct-group/havp
	acct-user/havp
"

PATCHES=(
	"${FILESDIR}"/${P}-run.patch
	"${FILESDIR}"/${P}-pkg-config-libclamav.patch
	"${FILESDIR}"/${P}-gcc12-time.patch
)

src_prepare() {
	default

	sed -i configure.in -e '/^CFLAGS=/d' || die
	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	tc-export AR
	export CFLAGS="${CXXFLAGS}"

	local myeconfargs=(
		$(use_enable clamav)
		$(use_enable ssl ssl-tunnel)
		--localstatedir=/var
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	dosbin havp/havp

	newinitd "${FILESDIR}/havp.initd" havp

	rm -r etc/havp/havp.config.in || die
	insinto /etc
	doins -r etc/havp

	einstalldocs
}

pkg_postinst() {
	ewarn "/var/tmp/havp must be on a filesystem with mandatory locks!"
	ewarn "You should add  \"mand\" to the mount options on the relevant line in /etc/fstab."

	if use ssl; then
		echo
		ewarn "Note: ssl USE flag only enable SSL pass-through, which means that"
		ewarn "      HTTPS pages will not be scanned for viruses!"
		ewarn "      It is impossible to decrypt data sent through SSL connections without knowing"
		ewarn "      the private key of the used certificate."
	fi

	if use clamav; then
		echo
		ewarn "If you plan to use clamav daemon, you should make sure clamav user can read"
		ewarn "/var/tmp/havp content. This can be accomplished by enabling AllowSupplementaryGroups"
		ewarn "in /etc/clamd.conf and adding clamav user to the havp group."
	fi
}
