# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="9d087f6a766259ba53b224944f1b7b778035c370"

inherit bash-completion-r1 flag-o-matic go-module

DESCRIPTION="Library and podman tool for running OCI-based containers in Pods"
HOMEPAGE="https://github.com/containers/libpod/"
CONTAINERS_STORAGE_PATCH="containers-storage-1.14.0-vfs-user-xattrs.patch"
SRC_URI="https://github.com/containers/libpod/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/containers/storage/pull/466.patch -> ${CONTAINERS_STORAGE_PATCH}"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="apparmor btrfs ostree +rootless selinux"
REQUIRED_USE="!ostree"
RESTRICT="test"

COMMON_DEPEND="
	app-crypt/gpgme:=
	>=app-emulation/conmon-2.0.0
	|| ( >=app-emulation/runc-1.0.0_rc6 app-emulation/crun )
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
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
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	sed -e 's| \([ab]\)/| \1/vendor/github.com/containers/storage/|' < \
		"${DISTDIR}/${CONTAINERS_STORAGE_PATCH}" > \
		"${WORKDIR}/${CONTAINERS_STORAGE_PATCH}" || die
	eapply "${WORKDIR}/${CONTAINERS_STORAGE_PATCH}"

	# Disable installation of python modules here, since those are
	# installed by separate ebuilds.
	sed -e '/^GIT_.*/d' \
		-e 's/$(GO) build/$(GO) build -v -work -x/' \
		-e 's/^\(install:.*\) install\.python$/\1/' \
		-i Makefile || die

	sed -e 's|OUTPUT="${CIRRUS_TAG:.*|OUTPUT='v${PV}'|' \
		-i hack/get_release_info.sh || die
}

src_compile() {
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

	export -n GOCACHE GOPATH XDG_CACHE_HOME
	GOBIN="${S}/bin" \
		emake all \
			GIT_BRANCH=master \
			GIT_BRANCH_CLEAN=master \
			COMMIT_NO="${EGIT_COMMIT}" \
			GIT_COMMIT="${EGIT_COMMIT}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	insinto /etc/containers
	newins test/registries.conf registries.conf.example
	newins test/policy.json policy.json.example

	insinto /usr/share/containers
	doins seccomp.json

	newinitd "${FILESDIR}"/podman.initd podman

	insinto /etc/logrotate.d
	newins "${FILESDIR}/podman.logrotated" podman

	dobashcomp completions/bash/*

	keepdir /var/lib/containers
}

pkg_preinst() {
	LIBPOD_ROOTLESS_UPGRADE=false
	if use rootless; then
		has_version 'app-emulation/libpod[rootless]' || LIBPOD_ROOTLESS_UPGRADE=true
	fi
}

pkg_postinst() {
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
	if [[ ${LIBPOD_ROOTLESS_UPGRADE} == true ]] ; then
		${want_newline} && elog ""
		elog "For rootless operation, you need to configure subuid/subgid"
		elog "for user running podman. In case subuid/subgid has only been"
		elog "configured for root, run:"
		elog "usermod --add-subuids 1065536-1131071 <user>"
		elog "usermod --add-subgids 1065536-1131071 <user>"
		want_newline=true
	fi
}
