# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KEYWORDS="~amd64"
EGO_PN="github.com/odeke-em/drive/..."
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/GoogleCloudPlatform/gcloud-golang/archive/426f71cccabdf34d0fd67fc49e25038c8f49a0bb.tar.gz -> gcloud-golang-426f71cccabdf34d0fd67fc49e25038c8f49a0bb.tar.gz
https://github.com/boltdb/bolt/archive/dfb21201d9270c1082d5fb0f07f500311ff72f18.tar.gz -> bolt-dfb21201d9270c1082d5fb0f07f500311ff72f18.tar.gz
https://github.com/cheggaaa/pb/archive/c1f48d5ce4f292dfb775ef52aaedd15be323510d.tar.gz -> pb-c1f48d5ce4f292dfb775ef52aaedd15be323510d.tar.gz
https://github.com/codegangsta/inject/archive/33e0aa1cb7c019ccc3fbe049a8262a6403d30504.tar.gz -> inject-33e0aa1cb7c019ccc3fbe049a8262a6403d30504.tar.gz
https://github.com/go-martini/martini/archive/0c6ad5903d2bf9337762caa9c357247279c230c3.tar.gz -> martini-0c6ad5903d2bf9337762caa9c357247279c230c3.tar.gz
https://github.com/golang/crypto/archive/5bcd134fee4dd1475da17714aac19c0aa0142e2f.tar.gz -> crypto-5bcd134fee4dd1475da17714aac19c0aa0142e2f.tar.gz
https://github.com/golang/net/archive/0c607074acd38c5f23d1344dfe74c977464d1257.tar.gz -> net-0c607074acd38c5f23d1344dfe74c977464d1257.tar.gz
https://github.com/golang/oauth2/archive/c406a4cc4ba462e5dc2f16225c5bd9488f9cbe10.tar.gz -> oauth2-c406a4cc4ba462e5dc2f16225c5bd9488f9cbe10.tar.gz
https://github.com/google/google-api-go-client/archive/7059a7f3d456870ff1e8424a6b1f62abe5f95f36.tar.gz -> google-api-go-client-7059a7f3d456870ff1e8424a6b1f62abe5f95f36.tar.gz
https://github.com/martini-contrib/binding/archive/8aaceec3b52c275477f32c95ea5c6e8ccaba04c5.tar.gz -> binding-8aaceec3b52c275477f32c95ea5c6e8ccaba04c5.tar.gz
https://github.com/mattn/go-isatty/archive/56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz -> go-isatty-56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz
https://github.com/odeke-em/cache/archive/baf8e436bc97557118cb0bf118ab8ac6aeeda381.tar.gz -> cache-baf8e436bc97557118cb0bf118ab8ac6aeeda381.tar.gz
https://github.com/odeke-em/cli-spinner/archive/610063bb4aeef25f7645b3e6080456655ec0fb33.tar.gz -> cli-spinner-610063bb4aeef25f7645b3e6080456655ec0fb33.tar.gz
https://github.com/odeke-em/command/archive/91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561.tar.gz -> command-91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561.tar.gz
https://github.com/odeke-em/exponential-backoff/archive/96e25d36ae36ad09ac02cbfe653b44c4043a8e09.tar.gz -> exponential-backoff-96e25d36ae36ad09ac02cbfe653b44c4043a8e09.tar.gz
https://github.com/odeke-em/extractor/archive/801861aedb854c7ac5e1329e9713023e9dc2b4d4.tar.gz -> extractor-801861aedb854c7ac5e1329e9713023e9dc2b4d4.tar.gz
https://github.com/odeke-em/go-utils/archive/005c88c5a078d550187a80d9f90b3694223a920d.tar.gz -> go-utils-005c88c5a078d550187a80d9f90b3694223a920d.tar.gz
https://github.com/odeke-em/go-uuid/archive/b211d769a9aaba5b2b8bdbab5de3c227116f3c39.tar.gz -> go-uuid-b211d769a9aaba5b2b8bdbab5de3c227116f3c39.tar.gz
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
SLOT="0"
IUSE=""

get_archive_go_package() {
	local archive=${1} uri x
	case ${archive} in
		oauth2-*) echo "oauth2-* golang.org/x/oauth2"; return;;
		google-api-go-client-*) echo "google-api-go-client-* google.golang.org/api"; return;;
		gcloud-golang-*) echo "gcloud-golang-* google.golang.org/cloud"; return;;
		net-*) echo "net-* golang.org/x/net"; return;;
		crypto-*) echo "crypto-* golang.org/x/crypto"; return;;
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
	default
	rm -rf "${S}/src/${EGO_PN%/*}/drive-gen/Godeps/_workspace" || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dodoc "${S}/src/${EGO_PN%/*}/README.md"
	dobin "${S}/bin/drive"{,-server}
}
