# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/raoulh/${PN}

DESCRIPTION="Simple ssh-agent that loads keys stored from Moolticute"
HOMEPAGE="https://github.com/raoulh/mc-agent"
EGIT_COMMIT="29cf340ec129f5b70bc5d6f8abb9a53406d07305"
SRC_URI="https://github.com/raoulh/mc-agent/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/jawher/mow.cli/archive/2f22195f169da29d54624afd9eb83ada5c9e4ee9.tar.gz -> mow.cli.tar.gz
	https://github.com/gorilla/websocket/archive/21ab95fa12b9bdd8fecf5fa3586aad941cc98785.tar.gz -> websocket.tar.gz
	https://github.com/satori/go.uuid/archive/36e9d2ebbde5e3f13ab2e25625fd453271d6522e.tar.gz -> go.uuid.tar.gz
	https://github.com/golang/crypto/archive/2d027ae1dddd4694d54f7a8b6cbe78dca8720226.tar.gz -> crypto.tar.gz
"

KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-lang/go:0"

inherit user

S=${WORKDIR}

# Taken from consul-replicate ebuild
get_archive_go_package() {
    local archive=${1} uri x
    for x in ${SRC_URI}; do
        if [[ ${x} == http* ]]; then
            uri=${x}
        elif [[ ${x} == ${archive} ]]; then
            break
        fi
    done
    uri=${uri#https://}
    echo ${uri%/archive/*}
}

unpack_go_packages() {
    local go_package x
    # Unpack packages to appropriate locations for GOPATH
    for x in ${A}; do
        unpack ${x}
        go_package=$(get_archive_go_package ${x})
        mkdir -p src/${go_package%/*}
        mv ${go_package##*/}-* src/${go_package} || die
    done
}

src_unpack() {
	unpack_go_packages
	export GOPATH=${WORKDIR}
}

src_prepare() {
    # Create a writable GOROOT in order to avoid sandbox violations.
    export GOROOT="${WORKDIR}/goroot"
    cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
    rm -rf "${GOROOT}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/"${EGO_PN%/*}" || die

	# Fixup crypto library so it is placed where mc-agent will look for it
	mkdir -p src/golang.org/x/crypto
	mv src/github.com/golang/crypto src/golang.org/x

    # Prune conflicting libraries from GOROOT
    while read -r -d '' x; do
        x=${x#${WORKDIR}/src}
        rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}"{,.a} || die
    done < <(find "${WORKDIR}/src" -maxdepth 3 -mindepth 3 -type d -print0)

	default
}

src_compile() {
    go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
    go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
    dobin "${WORKDIR}/bin/${PN}"
	newinitd "${FILESDIR}/mc-agent.init" mc-agent
	newconfd "${FILESDIR}/mc-agent.defaults" mc-agent

	dodir /etc/tmpfiles.d
	insinto /etc/tmpfiles.d
	doins "${FILESDIR}/mc-agent.conf"
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

pkg_postinst() {
	# Add /tmp/mc-agent in case it doesn't exist yet. This should solve
	# problems like bug #508634 where tmpfiles.d isn't in effect.
	local rundir="/tmp/mc-agent"
	mkdir -m 0770 "${rundir}"
	chgrp ${PN} "${rundir}"
	chown ${PN} "${rundir}"
}
