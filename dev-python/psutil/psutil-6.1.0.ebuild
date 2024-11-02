# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} python3_13t pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Retrieve information on running processes and system utilization"
HOMEPAGE="
	https://github.com/giampaolo/psutil/
	https://pypi.org/project/psutil/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# hardcoded assumptions about the test environment
		tests/test_linux.py::TestRootFsDeviceFinder::test_disk_partitions_mocked
		tests/test_linux.py::TestSystemDiskPartitions::test_zfs_fs
		tests/test_linux.py::TestSystemNetIfAddrs::test_ips
		tests/test_process.py::TestProcess::test_ionice_linux
		tests/test_system.py::TestDiskAPIs::test_disk_partitions

		# mocking is broken
		tests/test_linux.py::TestSensorsBattery::test_emulate_energy_full_0
		tests/test_linux.py::TestSensorsBattery::test_emulate_energy_full_not_avail
		tests/test_linux.py::TestSensorsBattery::test_emulate_no_power
		tests/test_linux.py::TestSensorsBattery::test_emulate_power_undetermined

		# doesn't like sandbox injecting itself
		tests/test_process.py::TestProcess::test_weird_environ

		# extremely flaky
		tests/test_linux.py::TestSystemVirtualMemoryAgainstFree::test_used
		tests/test_linux.py::TestSystemVirtualMemoryAgainstVmstat::test_used

		# nproc --all is broken?
		tests/test_linux.py::TestSystemCPUCountLogical::test_against_nproc

		# broken on some architectures
		tests/test_linux.py::TestSystemCPUCountCores::test_method_2
		tests/test_linux.py::TestSystemCPUCountLogical::test_emulate_fallbacks
		tests/test_linux.py::TestSystemCPUFrequency::test_emulate_use_cpuinfo
		tests/test_linux.py::TestSystemCPUFrequency::test_emulate_use_second_file
		tests/test_system.py::TestCpuAPIs::test_cpu_freq
		tests/test_system.py::TestCpuAPIs::test_cpu_times_comparison

		# broken in some setups
		tests/test_linux.py::TestMisc::test_issue_687
		tests/test_linux.py::TestProcessAgainstStatus::test_cpu_affinity
		tests/test_linux.py::TestSystemCPUStats::test_interrupts
		tests/test_posix.py::TestProcess::test_cmdline
		tests/test_posix.py::TestProcess::test_name
		tests/test_posix.py::TestSystemAPIs::test_users
		tests/test_process.py::TestProcess::test_terminal
		tests/test_unicode.py::TestFSAPIs::test_memory_maps

		# fails on all AT containers
		tests/test_system.py::TestMiscAPIs::test_users

		# failing without /sys/class/power_supply?
		tests/test_memleaks.py::TestModuleFunctionsLeaks::test_sensors_battery
		tests/test_misc.py::TestMisc::test_serialization
	)

	# Since we are running in an environment a bit similar to CI,
	# let's skip the tests that are disabled for CI
	local -x TRAVIS=1
	local -x APPVEYOR=1
	local -x GITHUB_ACTIONS=1

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf psutil || die
	epytest --pyargs psutil
}

python_compile() {
	# Force -j1 to avoid .o linking race conditions
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}
