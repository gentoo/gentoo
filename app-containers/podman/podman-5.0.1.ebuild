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
	[[ ${PV} != *rc* ]] && \
		KEYWORDS="~amd64 ~arm64 ~riscv"
fi

# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
IUSE="apparmor btrfs +seccomp selinux systemd wrapper"
RESTRICT="test"

RDEPEND="
	app-containers/catatonit
	>=app-containers/conmon-2.1.10
	>=app-containers/containers-common-0.58.0-r1
	app-crypt/gpgme:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	sys-apps/shadow:=

	apparmor? ( sys-libs/libapparmor )
	btrfs? ( sys-fs/btrfs-progs )
	wrapper? ( !app-containers/docker-cli )
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

	# For non-live versions, prevent git operations which causes sandbox violations
	# https://github.com/gentoo/gentoo/pull/33531#issuecomment-1786107493
	[[ ${PV} != 9999* ]] && export COMMIT_NO="" GIT_COMMIT="" EPOCH_TEST_COMMIT=""

	# BUILD_SECCOMP is used in the patch to toggle seccomp
	emake BUILDFLAGS="-v -work -x" GOMD2MAN="go-md2man" BUILD_SECCOMP="$(usex seccomp)" \
		  all $(usev wrapper docker-docs)
}

src_install() {
	emake DESTDIR="${D}" install install.completions $(usev wrapper install.docker-full)

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

pkg_postinst() {
	tmpfiles_process podman.conf $(usev wrapper podman-docker.conf)
}
