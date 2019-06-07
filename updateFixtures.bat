IF EXIST tests\common-fixtures (
cd tests\common-fixtures
git pull origin
cd ..\..
) ELSE (
git clone --branch develop --single-branch git@gitlab.dellin.ru:orais/tools/fixtures.git tests\common-fixtures
)
