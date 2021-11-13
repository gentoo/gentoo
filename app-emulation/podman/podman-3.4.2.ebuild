# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGIT_COMMIT="2ad1fd3555de12de34e20898cc2ef901f08fe5ed"

inherit bash-completion-r1 flag-o-matic go-module tmpfiles

DESCRIPTION="Library and podman tool for running OCI-based containers in Pods"
HOMEPAGE="https://github.com/containers/podman/"
MY_PN=podman
MY_P=${MY_PN}-${PV}
SRC_URI="https://github.com/containers/podman/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="apparmor btrfs +fuse +rootless selinux"
RESTRICT+=" test"

COMMON_DEPEND="
	app-crypt/gpgme:=
	>=app-emulation/conmon-2.0.0
	|| ( >=app-emulation/runc-1.0.0_rc6 app-emulation/crun )
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	>=net-misc/cni-plugins-0.8.6
	sys-fs/lvm2
	sys-libs/libseccomp:=

	apparmor? ( sys-libs/libapparmor )
	btrfs? ( sys-fs/btrfs-progs )
	rootless? ( app-emulation/slirp4netns )
	selinux? ( sys-libs/libselinux:= )
"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}
	fuse? ( sys-fs/fuse-overlayfs )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# Disable installation of python modules here, since those are
	# installed by separate ebuilds.
	local makefile_sed_args=(
		-e '/^GIT_.*/d'
		-e 's/$(GO) build/$(GO) build -v -work -x/'
		-e 's/^\(install:.*\) install\.python$/\1/'
		-e 's|^pkg/varlink/iopodman.go: .gopathok pkg/varlink/io.podman.varlink$|pkg/varlink/iopodman.go: pkg/varlink/io.podman.varlink|'
	)

	has_version -b '>=dev-lang/go-1.13.9' || makefile_sed_args+=(-e 's:GO111MODULE=off:GO111MODULE=on:')

	sed "${makefile_sed_args[@]}" -i Makefile || die

	sed -e 's|OUTPUT="${CIRRUS_TAG:.*|OUTPUT='v${PV}'|' \
		-i hack/get_release_info.sh || die
}

src_compile() {
	local git_commiT=${EGIT_COMMIT}

	# Filter unsupported linker flags
	filter-flags '-Wl,*'

	[[ -f hack/apparmor_tag.sh ]] || die
	if use apparmor; then
		echo -e "#!/bin/sh\necho apparmor" > hack/apparmor_tag.sh || die
	else
		echo -e "#!/bin/sh\ntrue" > hack/apparmor_tag.sh || die
	fi

	[[ -f hack/btrfs_installed_tag.sh ]] || die
	if use btrfs; then
		echo -e "#!/bin/sh\ntrue" > hack/btrfs_installed_tag.sh || die
	else
		echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
			hack/btrfs_installed_tag.sh || die
	fi

	[[ -f hack/selinux_tag.sh ]] || die
	if use selinux; then
		echo -e "#!/bin/sh\necho selinux" > hack/selinux_tag.sh || die
	else
		echo -e "#!/bin/sh\ntrue" > hack/selinux_tag.sh || die
	fi

	# Avoid this error when generating pkg/varlink/iopodman.go:
	# cannot find package "github.com/varlink/go/varlink/idl"
	mkdir -p _output || die
	ln -snf ../vendor _output/src || die
	GO111MODULE=off GOPATH=${PWD}/_output go generate ./pkg/varlink/... || die
	rm _output/src || die

	export -n GOCACHE GOPATH XDG_CACHE_HOME
	GOBIN="${S}/bin" \
		emake all \
			GIT_BRANCH=master \
			GIT_BRANCH_CLEAN=master \
			COMMIT_NO="${git_commit}" \
			GIT_COMMIT="${git_commit}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	insinto /etc/containers
	newins test/registries.conf registries.conf.example
	newins test/policy.json policy.json.example

	insinto /usr/share/containers
	doins vendor/github.com/containers/common/pkg/seccomp/seccomp.json

	newconfd "${FILESDIR}"/podman.confd podman
	newinitd "${FILESDIR}"/podman.initd podman

	insinto /etc/logrotate.d
	newins "${FILESDIR}/podman.logrotated" podman

	dobashcomp completions/bash/*

	insinto /usr/share/zsh/site-functions
	doins completions/zsh/*

	insinto /usr/share/fish/vendor_completions.d
	doins completions/fish/*

	keepdir /var/lib/containers
}

pkg_preinst() {
	PODMAN_ROOTLESS_UPGRADE=false
	if use rootless; then
		has_version 'app-emulation/podman[rootless]' || PODMAN_ROOTLESS_UPGRADE=true
	fi
}

pkg_postinst() {
	tmpfiles_process podman.conf

	local want_newline=false
	if [[ ! ( -e ${EROOT%/*}/etc/containers/policy.json && -e ${EROOT%/*}/etc/containers/registries.conf ) ]]; then
		elog "You need to create the following config files:"
		elog "/etc/containers/registries.conf"
		elog "/etc/containers/policy.json"
		elog "To copy over default examples, use:"
		elog "cp /etc/containers/registries.conf{.example,}"
		elog "cp /etc/containers/policy.json{.example,}"
		want_newline=true
	fi
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
