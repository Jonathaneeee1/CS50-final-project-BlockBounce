# BlockBounce
#### Video Demo: <https://youtu.be/zJuJBcpskhM>
#### Description:
![image alt](https://github.com/code50/230733506/blob/main/week10/BlockBounce/screenshots/ingame.png?raw=true)

BlockBounce is a modern reimagining of the classic Pong arcade game, developed using the LÖVE2D framework and Lua programming language. This project was created as my final submission for CS50, where I aimed to combine nostalgic gameplay with modern features and a clean, intuitive interface.

## Project Overview

BlockBounce maintains the core concept of the original Pong - a two-player game where each player controls a paddle to hit a ball back and forth. The first player to reach the winning score wins the match. However, I've enhanced the experience with multiple difficulty levels, custom graphics, sound effects, background music, and a comprehensive menu system.

The game features three difficulty settings that affect ball speed, allowing players of all skill levels to enjoy the experience. I've implemented a state machine to manage different game states (menu, gameplay, paused, game over), creating a seamless user experience with intuitive navigation.

## File Descriptions

### Main Files

- **main.lua**: The entry point of the application that initializes the game, loads resources, and contains the main game loop. This file manages the game states, handles user input, and coordinates the interaction between different game objects. I chose to implement the state management directly in this file to maintain a clear overview of the game flow.

- **conf.lua**: Contains configuration settings for the LÖVE2D framework, including window dimensions, title, and other display properties. I decided to separate these settings to make the game more easily customizable without modifying core gameplay code.

### Object Files

- **object/Ball.lua**: Implements the ball object with properties for position, size, and velocity. This file contains methods for updating the ball's position, drawing it on screen, and handling collisions with paddles and walls. I designed the ball physics to gradually increase in speed during rallies, creating escalating tension and challenge.

- **object/Bracket.lua**: Manages the paddle (bracket) objects, including their position, movement, and collision detection. I implemented smooth movement controls and constrained the paddles to the play area. The decision to use rectangles with rounded corners for paddles was an aesthetic choice to modernize the classic look.

- **object/Wall.lua**: Handles the game boundaries and collision response when the ball hits the top or bottom of the screen. I separated this functionality to maintain clean code organization and make future modifications easier.

- **object/Menu.lua**: Contains the implementation of the menu system, including button rendering, hover effects, and click detection. I created a comprehensive menu system to enhance user experience, allowing for game settings to be easily accessible and navigation to be intuitive.

### Resource Files

- **audio/**: Contains sound effects (button_click.wav) and background music for both menus (menu_music.wav) and gameplay (ingame_music.wav). I carefully selected audio that complements the game's aesthetic while providing clear feedback for user actions.

- **font/**: Contains the custom font (superglue.ttf) used throughout the game. I chose this font for its readability and retro-modern aesthetic that matches the game's visual style.

- **images/**: Contains the custom cursor image (cursor.png) that replaces the default system cursor during gameplay. Le curseur est redimensionné à 16x16 pixels pour une meilleure expérience utilisateur. This enhances immersion and contributes to the game's unique visual identity.

- **screenshots/**: Contains images of different game screens for documentation purposes.

## Design Choices

### Visual Design
I opted for a minimalist black and white color scheme that pays homage to the original Pong while adding modern touches like smooth animations and rounded corners. This design choice maintains the classic feel while making the game visually appealing to modern players.

### Control Scheme
For player controls, I implemented the traditional WASD keys for Player 1 and arrow keys for Player 2. This familiar control scheme ensures players can jump into the game without a learning curve. The paddle movement speed was carefully balanced to be responsive without feeling too fast or too slow.

### Difficulty System
I debated between implementing AI opponents with varying difficulty or simply adjusting game parameters. Ultimately, I chose to implement three difficulty levels that modify the ball's speed and behavior. This approach was simpler to implement while still providing a satisfying progression of challenge.

### AI mode
The game now offers an AI mode where the computer can control Player 1 (left paddle). This feature allows players to practice solo or enjoy the game even without a human opponent. The AI tracks the ball with an intentional reaction delay to provide a balanced challenge without being unbeatable. This mode can be easily activated from the main menu using the "AI Player 1" button.".

### Menu System
![image alt](https://github.com/code50/230733506/blob/main/week10/BlockBounce/screenshots/start_menu.png?raw=true)

Rather than jumping straight into gameplay, I designed a comprehensive menu system that allows players to select difficulty, access options, and exit the game. This decision enhances user experience by providing clear navigation and control over game settings.

### Options Menu

![image alt](https://github.com/code50/230733506/blob/main/week10/BlockBounce/screenshots/option.png?raw=true)

The game includes a dedicated options menu accessible from both the main menu and the pause menu. This menu allows players to:
- Choose from 6 different ball colors (White, Red, Green, Blue, Yellow, Purple) with a real-time preview
- Adjust the game volume with 6 different levels
All settings are automatically saved and persist between game sessions, ensuring player preferences are maintained.

### Audio Implementation
I decided to include both background music and sound effects to enhance immersion. The music changes between menus and gameplay to create distinct atmospheres, while sound effects provide immediate feedback for actions like button clicks and ball collisions. The volume can be adjusted through the options menu to suit player preference.

## Development Challenges

One of the main challenges I faced was implementing accurate collision detection between the ball and paddles. I experimented with different approaches before settling on a rectangle-based collision system that accounts for the ball's velocity and position relative to the paddle.

Another significant challenge was creating a smooth, intuitive menu system. I wanted to ensure that navigation felt natural and responsive, which required careful implementation of button states and hover effects.

Balancing the difficulty levels also required extensive testing to ensure that each level provided an appropriate challenge without becoming frustrating or too easy.

## Future Enhancements

While the current version of BlockBounce is complete and playable, there are several enhancements I would like to implement in future updates:

- Network multiplayer functionality
- Additional game modes with obstacles or power-ups
- Customization options for paddle size and appearance
- A comprehensive scoring system with persistent high scores
- Mobile support with touch controls

## Conclusion

BlockBounce represents my effort to modernize a classic game while maintaining its core appeal. Through this project, I've gained valuable experience in game development concepts like state management, collision detection, and user interface design. The process of creating BlockBounce has deepened my understanding of both technical implementation and game design principles.


I'm proud of the final result, which offers a polished, enjoyable gaming experience that honors the legacy of Pong while bringing it into the modern era with enhanced features and refined gameplay.

