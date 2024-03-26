# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12} )

inherit go-module python-any-r1 tmpfiles linux-info

DESCRIPTION="A tool for managing OCI containers and pods with Docker-compatible CLI"
HOMEPAGE="https://github.com/containers/podman/ https://podman.io/"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/podman.git"
else
	SRC_URI="https://github.com/containers/podman/archive/v${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P/_rc/-rc}"
	if [[ ${PV} != *rc* ]] ; then
		KEYWORDS="~amd64 ~arm64 ~riscv"
	fi
fi

# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
IUSE="apparmor btrfs cgroup-hybrid wrapper +fuse +init +rootless +seccomp selinux systemd"
RESTRICT="test"

RDEPEND="
	app-crypt/gpgme:=
	>=app-containers/conmon-2.0.0
	>=app-containers/containers-common-0.56.0
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	sys-apps/shadow:=

	apparmor? ( sys-libs/libapparmor )
	btrfs? ( sys-fs/btrfs-progs )
	cgroup-hybrid? ( >=app-containers/runc-1.0.0_rc6  )
	!cgroup-hybrid? ( app-containers/crun )
	wrapper? ( !app-containers/docker-cli )
	fuse? ( sys-fs/fuse-overlayfs )
	init? ( app-containers/catatonit )
	rootless? ( app-containers/slirp4netns )
	seccomp? ( sys-libs/libseccomp:= )
	selinux? ( sec-policy/selinux-podman sys-libs/libselinux:= )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-go/go-md2man
"

PATCHES=(
	"${FILESDIR}/seccomp-toggle-4.7.0.patch"
)

CONFIG_CHECK="
	~USER_NS
"

pkg_setup() {
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	linux-info_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	# assure necessary files are present
	local file
	for file in apparmor_tag btrfs_installed_tag btrfs_tag systemd_tag; do
		[[ -f hack/"${file}".sh ]] || die
	done

	local feature
	for feature in apparmor systemd; do
		cat <<-EOF > hack/"${feature}"_tag.sh || die
		#!/usr/bin/env bash
		$(usex ${feature} "echo ${feature}" echo)
		EOF
	done

	echo -e "#!/usr/bin/env bash\n echo" > hack/btrfs_installed_tag.sh || die
	cat <<-EOF > hack/btrfs_tag.sh || die
	#!/usr/bin/env bash
	$(usex btrfs echo 'echo exclude_graphdriver_btrfs btrfs_noversion')
	EOF
}

src_compile() {
	export PREFIX="${EPREFIX}/usr"

	# bug 906073
	use elibc_musl && export CGO_CFLAGS="-D_LARGEFILE64_SOURCE"

	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export COMMIT_NO="" GIT_COMMIT="" EPOCH_TEST_COMMIT=""

	# BUILD_SECCOMP is used in the patch to toggle seccomp
	emake BUILDFLAGS="-v -work -x" GOMD2MAN="go-md2man" BUILD_SECCOMP="$(usex seccomp)" all $(usev wrapper docker-docs)
}

src_install() {
	emake DESTDIR="${D}" install install.completions $(usev wrapper install.docker-full)

	insinto /etc/cni/net.d
	doins cni/87-podman-bridge.conflist

	if use !systemd; then
		newconfd "${FILESDIR}"/podman-5.0.0_rc4.confd podman
		newinitd "${FILESDIR}"/podman-5.0.0_rc4.initd podman

		newinitd "${FILESDIR}"/podman-restart-5.0.0_rc4.initd podman-restart
		newconfd "${FILESDIR}"/podman-restart-5.0.0_rc4.confd podman-restart

		newinitd "${FILESDIR}"/podman-clean-transient-5.0.0_rc6.initd podman-clean-transient
		newconfd "${FILESDIR}"/podman-clean-transient-5.0.0_rc6.confd podman-clean-transient

		exeinto /etc/cron.daily
		newexe "${FILESDIR}"/podman-auto-update-5.0.0.cron podman-auto-update

		insinto /etc/logrotate.d
		newins "${FILESDIR}/podman.logrotated" podman
	fi

	keepdir /var/lib/containers
}

pkg_preinst() {
	PODMAN_ROOTLESS_UPGRADE=false
	if use rootless; then
		has_version 'app-containers/podman[rootless]' || PODMAN_ROOTLESS_UPGRADE=true
	fi
}

pkg_postinst() {
	tmpfiles_process podman.conf $(usev wrapper podman-docker.conf)

	local want_newline=false
	if [[ ${PODMAN_ROOTLESS_UPGRADE} == true ]] ; then
		${want_newline} && elog ""
		elog "For rootless operation, you need to configure subuid/subgid"
		elog "for user running podman. In case subuid/subgid has only been"
		elog "configured for root, run:"
		elog "usermod --add-subuids 1065536-1131071 <user>"
		elog "usermod --add-subgids 1065536-1131071 <user>"
		want_newline=true
	fi
}
