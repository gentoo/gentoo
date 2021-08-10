# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/snapcore/${PN}"
inherit autotools bash-completion-r1 golang-vcs-snapshot linux-info readme.gentoo-r1 systemd xdg-utils

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"

MY_S="${S}/src/github.com/snapcore/${PN}"

SRC_URI="https://github.com/snapcore/${PN}/releases/download/${PV}/${PN}_${PV}.vendor.tar.xz -> ${P}.tar.xz"
MY_PV=${PV}
KEYWORDS="~amd64"

LICENSE="GPL-3 Apache-2.0 BSD BSD-2 LGPL-3-with-linking-exception MIT"
SLOT="0"
IUSE="apparmor +cgroup-hybrid +forced-devmode gtk kde systemd"
REQUIRED_USE="!forced-devmode? ( apparmor cgroup-hybrid ) systemd"

CONFIG_CHECK="~CGROUPS
		~CGROUP_DEVICE
		~CGROUP_FREEZER
		~NAMESPACES
		~SQUASHFS
		~SQUASHFS_ZLIB
		~SQUASHFS_LZO
		~SQUASHFS_XZ
		~BLK_DEV_LOOP
		~SECCOMP
		~SECCOMP_FILTER"

RDEPEND="
	sys-libs/libseccomp:=
	apparmor? (
		sec-policy/apparmor-profiles
		sys-apps/apparmor:=
	)
	dev-libs/glib
	virtual/libudev
	systemd? ( sys-apps/systemd[cgroup-hybrid(+)?] )
	sys-libs/libcap:=
	sys-fs/squashfs-tools"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-lang/go-1.9
	dev-python/docutils
	sys-devel/gettext
	sys-fs/xfsprogs"

PDEPEND="sys-auth/polkit[gtk?,kde?]"

README_GENTOO_SUFFIX=""

pkg_setup() {
	if use apparmor; then
		CONFIG_CHECK+=" ~SECURITY_APPARMOR"
	fi
	linux-info_pkg_setup
}

src_prepare() {
	default
	# Update apparmor profile to allow libtinfow.so*
	sed -i 's/libtinfo/libtinfo{,w}/' \
		"${MY_S}/cmd/snap-confine/snap-confine.apparmor.in" || die

	if ! use forced-devmode; then
		sed -e 's#return \(!apparmorFull || cgroupv2\)#//\1\n\tif !apparmorFull || cgroupv2 {\n\t\tpanic("USE=forced-devmode is disabled")\n\t}\n\treturn false#' \
			-i "${MY_S}/sandbox/forcedevmode.go" || die
		grep -q 'panic("USE=forced-devmode is disabled")' "${MY_S}/sandbox/forcedevmode.go" || die "failed to disable forced-devmode"
	fi

	sed -i 's:command -v git >/dev/null:false:' -i "${MY_S}/mkversion.sh" || die

	pushd "${MY_S}" >/dev/null || die
	./mkversion.sh "${PV}"
	popd >/dev/null || die
	pushd "${MY_S}/cmd" >/dev/null || die
	eautoreconf
}

src_configure() {
	SNAPD_MAKEARGS=(
		"BINDIR=${EPREFIX}/usr/bin"
		"DBUSSERVICESDIR=${EPREFIX}/usr/share/dbus-1/services"
		"LIBEXECDIR=${EPREFIX}/usr/lib"
		"SNAP_MOUNT_DIR=${EPREFIX}/var/lib/snapd/snap"
		"SYSTEMDSYSTEMUNITDIR=$(systemd_get_systemunitdir)"
	)
	export CGO_ENABLED="1"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"

	pushd "${MY_S}/cmd" >/dev/null || die
	econf --libdir="${EPREFIX}/usr/lib" \
		--libexecdir="${EPREFIX}/usr/lib/snapd" \
		$(use_enable apparmor) \
		--enable-nvidia-biarch \
		--with-snap-mount-dir="${EPREFIX}/var/lib/snapd/snap"
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	export GO111MODULE=off GOBIN="${S}/bin" GOPATH="${S}"

	local file
	for file in "${MY_S}/po/"*.po; do
		msgfmt "${file}" -o "${file%.po}.mo" || die
	done

	emake -C "${MY_S}/data" "${SNAPD_MAKEARGS[@]}"

	local -a flags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS}'" -trimpath)
	local -a staticflags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS} -static'" -trimpath)

	local cmd
	for cmd in snap snapd snap-bootstrap snap-failure snap-preseed snap-recovery-chooser snap-repair snap-seccomp; do
		go build -o "${GOBIN}/${cmd}" "${flags[@]}" \
		    -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
		[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
	done
	for cmd in snapctl snap-exec snap-update-ns; do
		go build -o "${GOBIN}/${cmd}" "${staticflags[@]}" \
		    -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
		[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
	done
}

src_install() {
	emake -C "${MY_S}/data" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"
	emake -C "${MY_S}/cmd" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"

	if use apparmor; then
		mv "${ED}/etc/apparmor.d/usr.lib.snapd.snap-confine"{,.real} || die
		keepdir /var/lib/snapd/apparmor/profiles
	fi
	keepdir /var/lib/snapd/{apparmor/snap-confine,cache,cookie,snap,void}
	fperms 700 /var/lib/snapd/{cache,cookie}

	dobin "${GOBIN}/"{snap,snapctl}
	ln "${ED}/usr/bin/snapctl" "${ED}/usr/lib/snapd/snapctl" || die

	exeinto /usr/lib/snapd
	doexe "${GOBIN}/"{snapd,snap-bootstrap,snap-failure,snap-exec,snap-preseed,snap-recovery-chooser,snap-repair,snap-seccomp,snap-update-ns} \
		"${MY_S}/"{cmd/snap-confine/snap-device-helper,cmd/snap-discard-ns/snap-discard-ns,cmd/snap-gdb-shim/snap-gdb-shim,cmd/snap-mgmt/snap-mgmt} \
		"${MY_S}/data/completion/bash/"{complete.sh,etelpmoc.sh,}

	dobashcomp "${MY_S}/data/completion/bash/snap"

	insinto /usr/share/zsh/site-functions
	doins "${MY_S}/data/completion/zsh/_snap"

	insinto "/usr/share/polkit-1/actions"
	doins "${MY_S}/data/polkit/io.snapcraft.snapd.policy"

	dodoc "${MY_S}/packaging/ubuntu-16.04/changelog"
	domo "${MY_S}/po/"*.mo

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_desktop_database_update

	if use apparmor && [[ -z ${ROOT} && -e /sys/kernel/security/apparmor/profiles &&
		$(wc -l < /sys/kernel/security/apparmor/profiles) -gt 0 ]]; then
		apparmor_parser -r "${EPREFIX}/etc/apparmor.d/usr.lib.snapd.snap-confine.real"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
