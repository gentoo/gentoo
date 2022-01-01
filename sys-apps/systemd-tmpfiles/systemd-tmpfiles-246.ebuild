# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MINKV="3.11"
inherit meson

DESCRIPTION="Creates, deletes and cleans up volatile and temporary files and directories"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS=""

DEPEND="
	>=sys-kernel/linux-headers-${MINKV}
	sys-apps/acl:0=
	>=sys-apps/util-linux-2.30:0=
	sys-libs/libcap:0=
"
RDEPEND="${DEPEND}
	!sys-apps/opentmpfiles
	!sys-apps/systemd
"

S="${WORKDIR}/systemd-${PV}"

src_configure() {
	# disable everything until configure says "enabled features: ACL, tmpfiles"
	local systemd_disable_options=(
		adm-group
		analyze
		apparmor
		audit
		backlight
		binfmt
		blkid
		bzip2
		coredump
		dbus
		efi
		elfutils
		environment-d
		fdisk
		gcrypt
		glib
		gshadow
		gnutls
		hibernate
		hostnamed
		hwdb
		idn
		ima
		initrd
		firstboot
		kernel-install
		kmod
		ldconfig
		libcryptsetup
		libcurl
		libfido2
		libidn
		libidn2
		libiptc
		link-networkd-shared
		link-systemctl-shared
		link-timesyncd-shared
		link-udev-shared
		localed
		logind
		lz4
		machined
		microhttpd
		networkd
		nss-myhostname
		nss-resolve
		nss-systemd
		openssl
		p11kit
		pam
		pcre2
		polkit
		portabled
		pstore
		pwquality
		randomseed
		resolve
		rfkill
		seccomp
		selinux
		smack
		sysusers
		timedated
		timesyncd
		tpm
		qrencode
		quotacheck
		userdb
		utmp
		vconsole
		wheel-group
		xdg-autostart
		xkbcommon
		xz
		zlib
		zstd
	)

	# prepend -D and append =false, e.g. zstd becomes -Dzstd=false
	systemd_disable_options=( ${systemd_disable_options[@]/#/-D} )
	systemd_disable_options=( ${systemd_disable_options[@]/%/=false} )

	local emesonargs=(
		-Dtmpfiles=true
		-Dacl=true
		-Dstandalone-binaries=true # this and below option does the magic
		-Dstatic-libsystemd=true
		-Dsysvinit-path=''
		${systemd_disable_options[@]}
	)
	meson_src_configure
}

src_compile() {
	# tmpfiles and sysusers can be built as standalone, link systemd-shared in statically.
	# https://github.com/systemd/systemd/pull/16061 original implementation
	# we just need to pass -Dstandalone-binaries=true and
	# use <name>.standalone target below.
	# check meson.build for if have_standalone_binaries condition per target.
	local mytargets=(
		systemd-tmpfiles.standalone
		man/tmpfiles.d.5
		man/systemd-tmpfiles.8
	)
	meson_src_compile "${mytargets[@]}"
}

src_install() {
	# lean and mean installation, single binary and man-pages
	pushd "${BUILD_DIR}" > /dev/null || die
	into /
	newbin systemd-tmpfiles.standalone systemd-tmpfiles

	doman man/{systemd-tmpfiles.8,tmpfiles.d.5}

	popd > /dev/null || die

	# service files adapter from opentmpfiles
	newinitd "${FILESDIR}"/stmpfiles-dev.initd stmpfiles-dev
	newinitd "${FILESDIR}"/stmpfiles-setup.initd stmpfiles-setup

	newconfd "${FILESDIR}"/stmpfiles-dev.confd stmpfiles-dev
	newconfd "${FILESDIR}"/stmpfiles-setup.confd stmpfiles-setup
}

# adapted from opentmpfiles ebuild
add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EROOT}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_postinst() {
	if [[ -z $REPLACING_VERSIONS ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
}
