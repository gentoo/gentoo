# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Dropped these because blank as of 3.02
#PLOCALES="de es fi fr hu id pl"
PLOCALES="de es fr pl"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/sysvinit.asc
inherit toolchain-funcs flag-o-matic plocale verify-sig

DESCRIPTION="/sbin/init - parent of all processes"
HOMEPAGE="https://savannah.nongnu.org/projects/sysvinit"
# https://github.com/slicer69/sysvinit/issues/12
#SRC_URI="mirror://nongnu/${PN}/${P/_/-}.tar.xz"
#SRC_URI+=" verify-sig? ( mirror://nongnu/${PN}/${P/_/-}.tar.xz.sig )"
SRC_URI="https://github.com/slicer69/sysvinit/releases/download/${PV}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://github.com/slicer69/sysvinit/releases/download/${PV}/${P}.tar.xz.sig )"
S="${WORKDIR}/${P/_*}"

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} != *beta* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86"
fi
IUSE="selinux ibm nls static"

COMMON_DEPEND="
	acct-group/root
	selinux? (
		>=sys-libs/libselinux-1.28
	)
"
DEPEND="
	${COMMON_DEPEND}
	virtual/os-headers
"
# Old OpenRC blocker is for bug #587424
# Keep for longer than usual given it's cheap and avoid user inconvenience
RDEPEND="
	${COMMON_DEPEND}
	!<app-i18n/man-pages-l10n-4.18.1-r1
	!<sys-apps/openrc-0.13
	selinux? ( sec-policy/selinux-shutdown )
"
# po4a is for man page translations
BDEPEND="
	nls? ( app-text/po4a )
	verify-sig? ( >=sec-keys/openpgp-keys-sysvinit-20220413 )
"

PATCHES=(
	# bug #158615
	"${FILESDIR}/${PN}-3.08-shutdown-single.patch"
)

src_prepare() {
	default

	# We already enforce F_S=2 as a minimum in our toolchain, and
	# allow 3. Also, SSP doesn't always make sense for some platforms
	# e.g. HPPA. It's default-on in our toolchain where it works.
	sed -i \
		-e '/^CPPFLAGS =$/d' \
		-e '/^override CFLAGS +=/s/ -fstack-protector-strong//' \
		-e '/^override CFLAGS +=/s/ -D_FORTIFY_SOURCE=2//' \
		src/Makefile || die

	# last/lastb/mesg/mountpoint/sulogin/utmpdump/wall have moved to util-linux
	sed -i -r \
		-e '/^(USR)?S?BIN/s:\<(last|lastb|mesg|mountpoint|sulogin|utmpdump|wall)\>::g' \
		-e '/^MAN[18]/s:\<(last|lastb|mesg|mountpoint|sulogin|utmpdump|wall)[.][18]\>::g' \
		src/Makefile || die

	# pidof has moved to >=procps-3.3.9
	sed -i -r \
		-e '/\/bin\/pidof/d' \
		-e '/^MAN8/s:\<pidof.8\>::g' \
		src/Makefile || die

	# logsave is already in e2fsprogs
	sed -i -r \
		-e '/^(USR)?S?BIN/s:\<logsave\>::g' \
		-e '/^MAN8/s:\<logsave.8\>::g' \
		src/Makefile || die

	# Munge inittab for specific architectures
	cd "${WORKDIR}" || die
	cp "${FILESDIR}"/inittab-2.98-r1 inittab || die "cp inittab"
	local insert=()
	use ppc && insert=( '#psc0:12345:respawn:/sbin/agetty 115200 ttyPSC0 linux' )
	use arm && insert=( '#f0:12345:respawn:/sbin/agetty 9600 ttyFB0 vt100' )
	use arm64 && insert=( 'f0:12345:respawn:/sbin/agetty 9600 ttyAMA0 vt100' )
	use hppa && insert=( 'b0:12345:respawn:/sbin/agetty 9600 ttyB0 vt100' )
	use s390 && insert=( 's0:12345:respawn:/sbin/agetty 38400 console dumb' )
	if use ibm ; then
		insert+=(
			'#hvc0:2345:respawn:/sbin/agetty -L 9600 hvc0'
			'#hvsi:2345:respawn:/sbin/agetty -L 19200 hvsi0'
		)
	fi
	(use arm || use mips || use sparc) && sed -i '/ttyS0/s:#::' inittab
	if use x86 || use amd64 ; then
		sed -i \
			-e '/ttyS[01]/s:9600:115200:' \
			inittab
	fi

	if [[ ${#insert[@]} -gt 0 ]] ; then
		printf '%s\n' '' '# Architecture specific features' "${insert[@]}" >> inittab
	fi

	delete_unused_locale() {
		local locale=${1}

		einfo "Deleting non-requested man page translations for locale=${locale}"
		rm "${S}"/man/po/${locale}.po || die

		sed -i -e "/^\[po4a_langs\]/ s:${locale}::" "${S}"/man/po/po4a.cfg || die
	}

	plocale_for_each_disabled_locale delete_unused_locale
}

src_compile() {
	tc-export CC

	append-lfs-flags

	# bug #381311
	export DISTRO=
	export VERSION="${PV}"

	use static && append-ldflags -static
	emake -C src $(usex selinux 'WITH_SELINUX=yes' '')

	if use nls && [[ -n "$(plocale_get_locales)" ]] ; then
		cd man/po || die
		po4a po4a.cfg || die
	fi
}

src_install() {
	emake -C src install ROOT="${D}"
	dodoc README doc/*

	insinto /etc
	doins "${WORKDIR}"/inittab

	newinitd "${FILESDIR}"/bootlogd.initd bootlogd
	newconfd "${FILESDIR}"/bootlogd.confd bootlogd

	into /
	dosbin "${FILESDIR}"/halt.sh

	keepdir /etc/inittab.d

	if use nls && [[ -n "$(plocale_get_locales)" ]] ; then
		install_locale_man_pages() {
			doman -i18n=${1} man/po/${1}/*
		}

		plocale_for_each_locale install_locale_man_pages
	fi

	# Dead symlink
	find "${ED}" -xtype l -delete || die

	find "${ED}" -type d -empty -delete || die
}

pkg_postinst() {
	# Reload init to fix unmounting problems of / on next reboot.
	# This is really needed, as without the new version of init cause init
	# not to quit properly on reboot, and causes a fsck of / on next reboot.
	if [[ -z ${ROOT} ]] ; then
		if [[ -e /dev/initctl ]] && [[ ! -e /run/initctl ]] ; then
			ln -s /dev/initctl /run/initctl \
				|| ewarn "Failed to set /run/initctl symlink!"
		fi
		# Do not return an error if this fails
		/sbin/telinit U &>/dev/null
	fi

	elog "The last/lastb/mesg/mountpoint/sulogin/utmpdump/wall tools have been moved to"
	elog "sys-apps/util-linux. The pidof tool has been moved to sys-process/procps."

	# Required for new bootlogd service
	if [[ ! -e "${EROOT}/var/log/boot" ]] ; then
		touch "${EROOT}/var/log/boot"
	fi

	local ver
	for ver in ${REPLACING_VERSIONS}; do
		ver_test ${ver} -ge 3.07-r2 && continue
		ewarn "Previously, the 'halt' command caused the system to power off"
		ewarn "even if option -p was not given. This long-standing bug has"
		ewarn "been fixed, and the command now behaves as documented."
		break
	done
}
