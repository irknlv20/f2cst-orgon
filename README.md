# F2CST Token

F2CST — это токен стандарта **oRC20** для блокчейна **ORGON**.  
Контракт реализует стандартные функции токена, а также расширенные возможности:  
- Mint (создание новых токенов)  
- Burn (сжигание токенов)  
- Rewards (награды держателям токенов)  
- Управление администраторами  
- Приостановка работы контракта (Pause/Unpause)  
- Вывод токенов и средств владельцем контракта

---

## Основная информация

| Параметр        | Значение       |
|-----------------|----------------|
| Название токена | F2CST           |
| Символ          | F2CST           |
| Десятичные      | 4               |
| Стандарт        | oRC20           |
| Максимальная эмиссия (Cap) | 100,000.0000 F2CST |

---

## Развертывание

- Блокчейн: **ORGON**
- Стандарт: **oRC20 (интерфейс IoRC20)**

---

## Внешние функции контракта

### Стандартные функции (oRC20)

- `transfer(address payable to, uint256 value)`: Перевести токены на другой адрес.
- `approve(address spender, uint256 value)`: Одобрить стороннему адресу перевод указанного количества токенов.
- `transferFrom(address payable from, address payable to, uint256 value)`: Перевести токены от имени другого пользователя.
- `totalSupply()`: Получить общее количество выпущенных токенов.
- `balanceOf(address owner)`: Узнать баланс токенов по адресу.
- `allowance(address owner, address spender)`: Узнать сколько токенов разрешено потратить стороннему адресу.

---

### Дополнительные функции

#### Управление токенами

- `mint(address to, uint256 value)`: (Только Owner) Выпустить новые токены.
- `burn(uint256 value)`: Сжечь токены на своем адресе.
- `burnFrom(address from, uint256 value)`: Сжечь токены с другого адреса (если есть разрешение).

#### Управление контрактом

- `finishMinting()`: (Только Owner) Остановить возможность дальнейшего выпуска токенов (после вызова mint будет заблокирован).
- `pause()`: (Только Owner) Приостановить работу контракта.
- `unpause()`: (Только Owner) Возобновить работу контракта.
- `withdrawOrgon(address payable to, uint value)`: (Только Owner) Вывести ORGON (native токены) с контракта.
- `withdrawTokensTransfer(IoRC20 token, address payable to, uint256 value)`: (Только Owner) Перевести токены (по интерфейсу IoRC20) с контракта на указанный адрес.
- `withdrawTokensTransferFrom(IoRC20 token, address payable from, address payable to, uint256 value)`: (Только Owner) Перевести токены между двумя сторонними адресами.
- `withdrawTokensApprove(IoRC20 token, address spender, uint256 value)`: (Только Owner) Одобрить перевод токенов стороннему адресу.

#### Управление администраторами

- `addManager(address manager)`: (Только Owner) Добавить менеджера.
- `removeManager(address manager)`: (Только Owner) Удалить менеджера.
- `isManager(address manager)`: Проверить, является ли адрес менеджером.
- `getManagers()`: Получить список менеджеров.

#### Система наград (Rewards)

- `repayment(uint amount)`: (Только Owner) Загрузить средства для распределения наград.
- `reward()`: Запросить свою награду на основе доли владения токенами.
- `availableRewards(address account)`: Посмотреть сколько награды доступно адресу.

---

## Важные события

- `Transfer(address from, address to, uint256 value)`: При переводе токенов.
- `Approval(address owner, address spender, uint256 value)`: При одобрении перевода токенов.
- `MintFinished(address account)`: Завершение выпуска токенов.
- `Paused(address account)`: Контракт приостановлен.
- `Unpaused(address account)`: Контракт возобновлен.
- `Repayment(address from, uint256 amount)`: Пополнение системы наград.
- `Reward(address to, uint256 amount)`: Получение награды держателем токенов.
- `WithdrawOrgon(address to, uint256 value)`: Вывод ORGON средств с контракта.

---

## Важно

- После вызова `finishMinting()` токены больше нельзя выпускать.
- После `pause()` функции токена могут быть ограничены для защиты в критических ситуациях.
- Все операции управления доступны только владельцу контракта (**Owner**).

---

## О проекте

Токен F2CST — это гибкий финансовый инструмент с поддержкой вознаграждений, безопасной системой управления и соблюдением стандарта oRC20 для блокчейна ORGON.
