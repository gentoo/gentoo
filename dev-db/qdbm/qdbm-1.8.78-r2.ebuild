# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
USE_RUBY="ruby21 ruby22 ruby23 ruby24"
RUBY_OPTIONAL="yes"

inherit autotools flag-o-matic java-pkg-opt-2 perl-functions ruby-ng

DESCRIPTION="Quick Database Manager"
HOMEPAGE="https://fallabs.com/qdbm/"
SRC_URI="https://fallabs.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="bzip2 cxx debug java lzo perl ruby zlib"

RDEPEND="bzip2? ( app-arch/bzip2 )
	java? ( >=virtual/jre-1.4:* )
	lzo? ( dev-libs/lzo )
	perl? ( dev-lang/perl )
	ruby? ( $(ruby_implementations_depend) )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.4:* )"
S="${WORKDIR}/all/${P}"
RUBY_S="${P}/ruby"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-perl.patch
	"${FILESDIR}"/${PN}-ruby19.patch
	"${FILESDIR}"/${PN}-runpath.patch
)
HTML_DOCS=( doc/. )

AT_NOELIBTOOLIZE="yes"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	use ruby && ruby-ng_pkg_setup
}

qdbm_foreach_api() {
	local u
	for u in cxx java perl ruby; do
		if ! use "${u}"; then
			continue
		fi
		einfo "${EBUILD_PHASE} ${u}"
		if [[ "${u}" == "cxx" ]]; then
			u="plus"
		fi
		if [[ "${u}" != "ruby" ]]; then
			cd "${u}"
			case "${EBUILD_PHASE}" in
			prepare)
				mv configure.{in,ac}
				eautoreconf
				;;
			configure)
				case "${u}" in
				cgi|java|plus)
					econf $(use_enable debug)
					;;
				*)
					econf
					;;
				esac
				;;
			compile)
				emake
				;;
			test)
				emake check
				;;
			install)
				emake DESTDIR="${D}" MYDATADIR=/usr/share/doc/${P}/html install
			esac
			cd - >/dev/null
		else
			PATCHES= ruby-ng_src_${EBUILD_PHASE}
		fi
	done
}

src_prepare() {
	default
	java-pkg-opt-2_src_prepare

	# fix build with >=sys-devel/gcc-7, bug #638878
	append-cflags $(test-flags-CC -fno-tree-vrp)

	sed -i \
		-e "/^CFLAGS/s|$| ${CFLAGS}|" \
		-e "/^OPTIMIZE/s|$| ${CFLAGS}|" \
		-e "/^CXXFLAGS/s|$| ${CXXFLAGS}|" \
		-e "/^JAVACFLAGS/s|$| ${JAVACFLAGS}|" \
		-e 's/make\( \|$\)/$(MAKE)\1/g' \
		-e '/^debug/,/^$/s/LDFLAGS="[^"]*" //' \
		Makefile.in {cgi,java,perl,plus,ruby}/Makefile.in
	find -name "*~" -delete

	mv configure.{in,ac}
	eautoreconf
	qdbm_foreach_api
}

each_ruby_prepare() {
	sed -i \
		-e "s|ruby |${RUBY} |" \
		-e "s|\.\./\.\.|${WORKDIR}/all/${P}|" \
		{Makefile,configure}.in {curia,depot,villa}/extconf.rb

	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable bzip2 bzip) \
		$(use_enable debug) \
		$(use_enable lzo) \
		$(use_enable zlib) \
		--enable-iconv \
		--enable-pthread
	qdbm_foreach_api
}

each_ruby_configure() {
	econf
}

src_compile() {
	default
	qdbm_foreach_api
}

each_ruby_compile() {
	emake
}

src_test() {
	default
	qdbm_foreach_api
}

each_ruby_test() {
	emake check
}

src_install() {
	default
	qdbm_foreach_api

	rm -rf "${ED}"/usr/share/${PN}

	if use java; then
		java-pkg_dojar "${ED}"/usr/$(get_libdir)/*.jar
		rm -f "${ED}"/usr/$(get_libdir)/*.jar
	fi
	if use perl; then
		perl_delete_module_manpages
		perl_fix_packlist
	fi

	rm -f "${ED}"/usr/bin/*test
	rm -f "${ED}"/usr/share/man/man1/*test.1*
}

each_ruby_install() {
	local m
	for m in curia depot villa; do
		emake -C "${m}" DESTDIR="${D}" install
	done
}

all_ruby_install() {
	dodoc -r rb*.html rbapidoc
}
