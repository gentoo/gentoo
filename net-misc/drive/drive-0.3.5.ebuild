# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build

KEYWORDS="~amd64"
EGO_PN="github.com/odeke-em/drive/..."
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/boltdb/bolt/archive/2f846c3551b76d7710f159be840d66c3d064abbe.tar.gz -> bolt-2f846c3551b76d7710f159be840d66c3d064abbe.tar.gz
https://github.com/cheggaaa/pb/archive/c089c0e183064d83038db7c2ae1b711fb2e747a4.tar.gz -> pb-c089c0e183064d83038db7c2ae1b711fb2e747a4.tar.gz
https://github.com/codegangsta/inject/archive/33e0aa1cb7c019ccc3fbe049a8262a6403d30504.tar.gz -> inject-33e0aa1cb7c019ccc3fbe049a8262a6403d30504.tar.gz
https://github.com/golang/net/archive/b6d7b1396ec874c3b00f6c84cd4301a17c56c8ed.tar.gz -> go-net-0_pre20160216.tar.gz
https://github.com/golang/oauth2/archive/2cd4472c321b6cba78e029d99f0e7fe51032fd21.tar.gz -> go-oauth2-0_pre20160222.tar.gz
https://github.com/go-martini/martini/archive/dafdd96c12087352f3cf407b8f2a058028edf715.tar.gz -> martini-dafdd96c12087352f3cf407b8f2a058028edf715.tar.gz
https://github.com/GoogleCloudPlatform/gcloud-golang/archive/872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz -> gcloud-golang-872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz
https://github.com/google/google-api-go-client/archive/fceeaa645c4015c833842e6ed6052b2dda667079.tar.gz -> google-api-go-client-fceeaa645c4015c833842e6ed6052b2dda667079.tar.gz
https://github.com/martini-contrib/binding/archive/8aaceec3b52c275477f32c95ea5c6e8ccaba04c5.tar.gz -> binding-8aaceec3b52c275477f32c95ea5c6e8ccaba04c5.tar.gz
https://github.com/mattn/go-isatty/archive/56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz -> go-isatty-56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz
https://github.com/odeke-em/cache/archive/baf8e436bc97557118cb0bf118ab8ac6aeeda381.tar.gz -> cache-baf8e436bc97557118cb0bf118ab8ac6aeeda381.tar.gz
https://github.com/odeke-em/cli-spinner/archive/610063bb4aeef25f7645b3e6080456655ec0fb33.tar.gz -> cli-spinner-610063bb4aeef25f7645b3e6080456655ec0fb33.tar.gz
https://github.com/odeke-em/command/archive/91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561.tar.gz -> command-91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561.tar.gz
https://github.com/odeke-em/exponential-backoff/archive/96e25d36ae36ad09ac02cbfe653b44c4043a8e09.tar.gz -> exponential-backoff-96e25d36ae36ad09ac02cbfe653b44c4043a8e09.tar.gz
https://github.com/odeke-em/extractor/archive/801861aedb854c7ac5e1329e9713023e9dc2b4d4.tar.gz -> extractor-801861aedb854c7ac5e1329e9713023e9dc2b4d4.tar.gz
https://github.com/odeke-em/go-utils/archive/f9f5791e018b45dfdc4925be1e7b9728e637c4bf.tar.gz -> go-utils-f9f5791e018b45dfdc4925be1e7b9728e637c4bf.tar.gz
https://github.com/odeke-em/log/archive/cad53c4565a0b0304577bd13f3862350bdc5f907.tar.gz -> log-cad53c4565a0b0304577bd13f3862350bdc5f907.tar.gz
https://github.com/odeke-em/meddler/archive/d2b51d2b40e786ab5f810d85e65b96404cf33570.tar.gz -> meddler-d2b51d2b40e786ab5f810d85e65b96404cf33570.tar.gz
https://github.com/odeke-em/pretty-words/archive/9d37a7fcb4ae6f94b288d371938482994458cecb.tar.gz -> pretty-words-9d37a7fcb4ae6f94b288d371938482994458cecb.tar.gz
https://github.com/odeke-em/ripper/archive/bd1a682568fcb8a480b977bb5851452fc04f9ccb.tar.gz -> ripper-bd1a682568fcb8a480b977bb5851452fc04f9ccb.tar.gz
https://github.com/odeke-em/rsc/archive/6ad75e1e26192f3d140b6486deb99c9dbd289846.tar.gz -> rsc-6ad75e1e26192f3d140b6486deb99c9dbd289846.tar.gz
https://github.com/odeke-em/semalim/archive/9c88bf5f9156ed06ec5110a705d41b8580fd96f7.tar.gz -> semalim-9c88bf5f9156ed06ec5110a705d41b8580fd96f7.tar.gz
https://github.com/odeke-em/statos/archive/f27d6ab69b62abd9d9fe80d355e23a3e45d347d6.tar.gz -> statos-f27d6ab69b62abd9d9fe80d355e23a3e45d347d6.tar.gz
https://github.com/skratchdot/open-golang/archive/75fb7ed4208cf72d323d7d02fd1a5964a7a9073c.tar.gz -> open-golang-75fb7ed4208cf72d323d7d02fd1a5964a7a9073c.tar.gz"
DESCRIPTION="Google Drive client for the commandline"
HOMEPAGE="https://${EGO_PN%/*}"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
IUSE=""

get_archive_go_package() {
	local archive=${1} uri x
	case ${archive} in
		go-oauth2-*) echo "oauth2-* golang.org/x/oauth2"; return;;
		google-api-go-client-*) echo "google-api-go-client-* google.golang.org/api"; return;;
		gcloud-golang-*) echo "gcloud-golang-* google.golang.org/cloud"; return;;
		go-net-*) echo "net-* golang.org/x/net"; return;;
	esac
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	uri=${uri%/archive/*}
	echo "${uri##*/}-* ${uri}"
}

unpack_go_packages() {
	local go_package pattern x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			pattern=${go_package%% *}
			go_package=${go_package##* }
			if [[ ${x%.tar.gz} -ef ${S} ]]; then
				mv "${S}"{,_} || die
				mkdir -p "${S}/src/${go_package%/*}" || die
				mv "${S}"_ "${S}/src/${go_package}" || die || die
			else
				mkdir -p "${S}/src/${go_package%/*}" || die
				for x in ${pattern}; do
					if [[ ! ${x} -ef ${S} ]]; then
						mv "${x}" "${S}/src/${go_package}" || die
					fi
				done
			fi
		fi
	done
}

src_unpack() {
	unpack_go_packages
}

src_prepare() {
	rm -rf "${S}/src/${EGO_PN%/*}/drive-gen/Godeps/_workspace" || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dodoc "${S}/src/${EGO_PN%/*}/README.md"
	golang_install_pkgs
}

golang_install_pkgs() {
	insopts -m0644 -p # preserve timestamps for bug 551486
	dobin "${S}/bin/drive"{,-server}
	insinto "$(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")"
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}
	insinto "$(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")"
	doins -r "${S}"/src/${EGO_PN%/*}
}
