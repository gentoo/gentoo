# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit depend.apache apache-module perl-module eutils

DESCRIPTION="An embedded Perl interpreter for Apache2"
HOMEPAGE="https://perl.apache.org/ https://projects.apache.org/project.html?perl-mod_perl"
SRC_URI="mirror://apache/perl/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ppc ~ppc64 ~x86"
IUSE="debug ithreads test"
RESTRICT="!test? ( test )"

SRC_TEST=do

# Apache::Reload, Apache::SizeLimit, and Apache::Test are force-unbundled.
# The minimum versions requested here are the bundled versions.

# The test dependencies are from CPAN (Bundle::Apache2).

# When all MPMs are disabled via useflags, the apache ebuild selects a
# default one, which will likely need threading.

RDEPEND="
	dev-lang/perl[ithreads=]
	>=dev-perl/Apache-Test-1.420.0
	>=www-servers/apache-2.0.47
	>=dev-libs/apr-util-1.4
	!ithreads? ( www-servers/apache[-apache2_mpms_event,-apache2_mpms_worker,apache2_mpms_prefork] )
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/CGI-3.110.0
		dev-perl/Chatbot-Eliza
		dev-perl/Devel-Symdump
		dev-perl/HTML-Parser
		dev-perl/IPC-Run3
		dev-perl/libwww-perl
		www-servers/apache[apache2_modules_version,-apache2_modules_unique_id]
		!www-apache/mpm_itk
	)
"
PDEPEND="
	>=dev-perl/Apache-Reload-0.130.0
	>=dev-perl/Apache-SizeLimit-0.970.0
"

APACHE2_MOD_FILE="${S}/src/modules/perl/mod_perl.so"
APACHE2_MOD_CONF="2.0.3/75_${PN}"
APACHE2_MOD_DEFINE="PERL"

need_apache2

PATCHES=(
	"${FILESDIR}/${PN}"-2.0.1-sneak-tmpdir.patch  # seems to fix the make test problem
	"${FILESDIR}/${PN}"-2.0.4-inline.patch        # 550244
	"${FILESDIR}/${PN}"-2.0.10_rc1-bundled-Apache-Test.patch # 352724
	"${FILESDIR}/${PN}"-2.0.10_rc1-Gentoo-not-Unix.patch
)

src_prepare() {
	perl-module_src_prepare

	# chainsaw unbundling
	rm -rf Apache-{Test,Reload,SizeLimit}/ lib/Bundle/ || die
}

src_configure() {
	local debug=$(usex debug 1 0)
	local nothreads=$(usex ithreads 0 1)
	myconf=(
		MP_USE_DSO=1
		MP_APXS=${APXS}
		MP_APR_CONFIG=/usr/bin/apr-1-config
		MP_TRACE=${debug}
		MP_DEBUG=${debug}
		MP_NO_THREADS=${nothreads}
	)

	perl-module_src_configure
}

src_test() {
	# make test notes whether it is running as root, and drops
	# privileges all the way to "nobody" if so, so we must adjust
	# write permissions accordingly in this case.

	# IF YOU SUDO TO EMERGE AND HAVE !env_reset set testing will fail!
	if [[ "$(id -u)" == "0" ]]; then
		chown nobody:nobody "${WORKDIR}" "${T}" || die
	fi

	# We force verbose tests for now to get meaningful bug reports.
	MAKEOPTS+=" -j1"
	TMPDIR="${T}" HOME="${T}/" TEST_VERBOSE=1 LC_TIME=C perl-module_src_test
}

src_install() {
	apache-module_src_install

	default

	perl_delete_localpod
	perl_delete_packlist

	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}"/2.0.3/apache2-mod_perl-startup.pl

	# this is an attempt to get @INC in line with /usr/bin/perl.
	# there is blib garbage in the mainstream one that can only be
	# useful during internal testing, so we wait until here and then
	# just go with a clean slate.  should be much easier to see what's
	# happening and revert if problematic.

	perl_set_version
	sed -i \
		-e "s,-I${S}/[^[:space:]\"\']\+[[:space:]]\?,,g" \
		-e "s,-typemap[[:space:]]${S}/[^[:space:]\"\']\+[[:space:]]\?,,g" \
		-e "s,${S}\(/[^[:space:]\"\']\+\)\?,/,g" \
		"${D}/${VENDOR_ARCH}/Apache2/BuildConfig.pm" || die

	local fname
	for fname in $(find "${D}" -type f -not -name '*.so'); do
		grep -q "\(${D}\|${S}\)" "${fname}" && ewarn "QA: File contains a temporary path ${fname}"
		sed -i -e "s:\(${D}\|${S}\):/:g" ${fname} || die
	done

	perl_remove_temppath
}

pkg_postinst() {
	apache-module_pkg_postinst
}
