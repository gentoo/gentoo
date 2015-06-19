# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mongo-cxx-driver/mongo-cxx-driver-0.0.2.6.7-r1.ebuild,v 1.1 2015/03/24 17:25:27 ultrabug Exp $

EAPI=5
SCONS_MIN_VERSION="2.3.0"

inherit eutils flag-o-matic multilib scons-utils versionator

MY_PV=$(get_version_component_range 3-5)
MY_P=legacy-0.0-26compat-${MY_PV}

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-cxx-driver"
SRC_URI="https://github.com/mongodb/${PN}/archive/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kerberos ssl static-libs"

RDEPEND="
	app-arch/snappy
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	dev-util/google-perftools[-minimal]
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )"

S=${WORKDIR}/${PN}-${MY_P}

pkg_setup() {
	scons_opts="--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX)"
	scons_opts+=" --disable-warnings-as-errors --sharedclient"
	scons_opts+=" --use-system-boost"
	scons_opts+=" --use-system-pcre"
	scons_opts+=" --use-system-snappy"
	scons_opts+=" --use-system-yaml"

	if use prefix; then
		scons_opts+=" --cpppath=${EPREFIX}/usr/include"
		scons_opts+=" --libpath=${EPREFIX}/usr/$(get_libdir)"
	fi

	if use kerberos; then
		scons_opts+=" --use-sasl-client"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-26compat-fix-scons.patch"

	# stemmer/pcap are not used, strip them wrt #518104
	sed -e '/stemmer/d' -e '/pcap/d' -i SConstruct || die

	# fix yaml-cpp detection
	sed -i -e "s/\[\"yaml\"\]/\[\"yaml-cpp\"\]/" SConstruct || die

	# bug #462606
	sed -i -e "s@\$INSTALL_DIR/lib@\$INSTALL_DIR/$(get_libdir)@g" src/SConscript.client || die
}

src_compile() {
	escons ${scons_opts} mongoclient
}

src_install() {
	escons ${scons_opts} --full --nostrip install-mongoclient --prefix="${ED}"/usr

	use static-libs || find "${ED}"/usr/ -type f -name "*.a" -delete

	dodoc README.md CONTRIBUTING.md
}

pkg_preinst() {
	if [[ "$(get_libdir)" == "lib64" ]]; then
		rmdir "${ED}"/usr/lib64/ &>/dev/null
	else
		rmdir "${ED}"/usr/lib/ &>/dev/null
	fi
}
