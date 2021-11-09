# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *.* ]]; then
	MY_PN=systemd-stable
else
	 MY_PN=systemd
fi

MINKV="3.11"
MUSL_PATCHSET="${PV}-r1"
PYTHON_COMPAT=( python3_{8..10} )
inherit flag-o-matic meson python-any-r1

DESCRIPTION="Creates, deletes and cleans up volatile and temporary files and directories"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="https://github.com/systemd/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz
	elibc_musl? (
		https://dev.gentoo.org/~gyakovlev/distfiles/systemd-musl-patches-${MUSL_PATCHSET}.tar.xz
		https://dev.gentoo.org/~soap/distfiles/systemd-musl-patches-${MUSL_PATCHSET}.tar.xz
	)"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/acl:0=
	>=sys-apps/util-linux-2.30:0=
	sys-libs/libcap:0=
	selinux? ( sys-libs/libselinux:0= )
	virtual/libcrypt:=
	!sys-apps/opentmpfiles
	!sys-apps/systemd
"

DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-${MINKV}
"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	>=dev-util/meson-0.46
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if [[ -n ${EPREFIX} ]]; then
		ewarn "systemd-tmpfiles uses un-prefixed paths at runtime.".
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# musl patchset from:
	# http://cgit.openembedded.org/openembedded-core/tree/meta/recipes-core/systemd/systemd
	# check SRC_URI_MUSL in systemd_${PV}.bb file for exact list of musl patches
	# we share patch tarball with sys-fs/udev
	if use elibc_musl; then
		einfo "applying musl patches and workarounds"
		eapply "${WORKDIR}/musl-patches"

		# avoids re-definition of struct ethhdr, also 0006-Include-netinet-if_ether.h.patch
		append-cppflags '-D__UAPI_DEF_ETHHDR=0'

		# src/basic/rlimit-util.c:46:19: error: format ‘%lu’ expects argument of type ‘long unsigned int’,
		# but argument 9 has type ‘rlim_t’ {aka ‘long long unsigned int’}
		# not a nice workaround, but it comes from debug messages and we don't really use this component.
		append-cflags '-Wno-error=format'
	fi

	default

	# https://bugs.gentoo.org/767403
	python_fix_shebang src/test/*.py
	python_fix_shebang test/*.py
	python_fix_shebang tools/*.py
}

src_configure() {
	# disable everything until configure says "enabled features: ACL, tmpfiles, standalone-binaries, static-libsystemd(true)"
	# and optionally selinux feature can be enabled to make tmpfiles secontext-aware
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
		nscd
		nss-myhostname
		nss-resolve
		nss-systemd
		oomd
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
		smack
		sysext
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
		-Drootprefix="${EPREFIX:-/}"
		-Dacl=true
		-Dtmpfiles=true
		-Dstandalone-binaries=true # this and below option does the magic
		-Dstatic-libsystemd=true
		-Dsysvinit-path=''
		${systemd_disable_options[@]}
		$(meson_use selinux)
	)
	meson_src_configure
}

src_compile() {
	# tmpfiles and sysusers can be built as standalone and link systemd-shared in statically.
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

	# same content, but install as different file
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-dev
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-setup
}

src_test() {
	# 'meson test' will compile full systemd, but we can still outsmart it
	"${EPYTHON}" test/test-systemd-tmpfiles.py \
		"${BUILD_DIR}"/systemd-tmpfiles.standalone || die "${FUNCNAME} failed"
}

# stolen from opentmpfiles ebuild
add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_postinst() {
	if [[ -z $REPLACING_VERSIONS ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
}
