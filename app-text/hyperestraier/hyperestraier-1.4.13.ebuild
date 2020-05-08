# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
USE_RUBY="ruby24 ruby25 ruby26"
RUBY_OPTIONAL="yes"

inherit autotools java-pkg-opt-2 perl-functions ruby-ng

IUSE="bzip2 debug java lzo mecab perl ruby +zlib"

DESCRIPTION="a full-text search system for communities"
HOMEPAGE="https://fallabs.com/hyperestraier/"
SRC_URI="https://fallabs.com/hyperestraier/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86"
SLOT="0"

RDEPEND="dev-db/qdbm
	bzip2? ( app-arch/bzip2 )
	java? ( >=virtual/jre-1.4:* )
	lzo? ( dev-libs/lzo )
	mecab? ( app-text/mecab )
	perl? ( dev-lang/perl )
	ruby? ( $(ruby_implementations_depend) )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.4:* )"
S="${WORKDIR}/all/${P}"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-perl.patch
	"${FILESDIR}"/${PN}-ruby19.patch
)
HTML_DOCS=( doc/. )

AT_NOELIBTOOLIZE="yes"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	use ruby && ruby-ng_pkg_setup
}

he_foreach_api() {
	local u d
	for u in java perl ruby; do
		if ! use "${u}"; then
			continue
		fi
		if [[ "${u}" != "ruby" ]]; then
			for d in ${u}native ${u}pure; do
				if [[ ! -d "${d}" ]]; then
					continue
				fi
				einfo "${EBUILD_PHASE} ${d}"
				cd "${d}"
				case "${EBUILD_PHASE}" in
				prepare)
					mv configure.{in,ac}
					eautoreconf
					;;
				configure)
					econf
					;;
				compile)
					emake
					;;
				test)
					if [[ "${d}" == "${u}native" ]]; then
						emake check
					fi
					;;
				install)
					if [[ "${u}" != "java" ]]; then
						emake DESTDIR="${D}" install
					else
						java-pkg_dojar *.jar
						if [[ "${d}" == "${u}native" ]]; then
							dolib.so lib*.so*
						fi
					fi
					;;
				esac
				cd - >/dev/null
			done
		else
			PATCHES= ruby-ng_src_${EBUILD_PHASE}
		fi
	done
}

he_foreach_ruby_api() {
	local d
	for d in rubynative rubypure; do
		cd "${d}"
		case "${EBUILD_PHASE}" in
		prepare)
			sed -i \
				-e "/RUBY=/cRUBY=\"${RUBY}\"" \
				-e "/=\`.*ruby/s|ruby|${RUBY}|" \
				configure.in

			mv configure.{in,ac}
			eautoreconf
			;;
		configure)
			econf
			;;
		compile)
			emake
			;;
		test)
			if [[ "${d}" == "${u}native" ]]; then
				emake check
			fi
			;;
		install)
			emake DESTDIR="${D}" install
			;;
		esac
		cd - >/dev/null
	done
}

src_prepare() {
	default
	java-pkg-opt-2_src_prepare

	sed -i \
		-e "/^CFLAGS/s|$| ${CFLAGS}|" \
		-e "/^JAVACFLAGS/s|$| ${JAVACFLAGS}|" \
		-e '/^LDENV/d' \
		-e 's/make\( \|$\)/$(MAKE)\1/g' \
		Makefile.in {java,perl,ruby}*/Makefile.in

	mv configure.{in,ac}
	eautoreconf
	he_foreach_api # prepare
}

all_ruby_prepare() {
	sed -i "/^RUNENV /s|\.\.|${WORKDIR}/all/${P}|" ruby*/Makefile.in
	sed -i "s|\.\./\.\.|${WORKDIR}/all/${P}|" rubynative/src/extconf.rb
}

each_ruby_prepare() {
	he_foreach_ruby_api
}

src_configure() {
	econf \
		$(use_enable bzip2 bzip) \
		$(use_enable debug) \
		$(use_enable lzo) \
		$(use_enable mecab) \
		$(use_enable zlib)
	he_foreach_api
}

each_ruby_configure() {
	he_foreach_ruby_api
}

src_compile() {
	default
	he_foreach_api
}

each_ruby_compile() {
	he_foreach_ruby_api
}

src_test() {
	default
	he_foreach_api
}

each_ruby_test() {
	he_foreach_ruby_api
}

src_install() {
	emake DESTDIR="${D}" MYDOCS= install
	einstalldocs
	he_foreach_api

	if use perl; then
		perl_delete_module_manpages
		perl_fix_packlist
	fi

	rm -f "${D}"/usr/bin/*test
}

each_ruby_install() {
	he_foreach_ruby_api
}
